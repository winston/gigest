require 'spec_helper'

describe Gigest::GithubConnection do
  let(:connection) { Gigest::GithubConnection.new(access_token: ENV["GIGEST_TEST_GITHUB_TOKEN"]) }

	describe "#initialize" do
    before do
      Octokit::Client.stub(:new)
      Gigest::GithubConnection.new(auth_params)
    end

    context "with GitHub username and password" do
      let(:auth_params) { {login: "username", password: "password"} }

      it { Octokit::Client.should have_received(:new).with(auth_params) }
    end

    context "with OAuth" do
      let(:auth_params) { {access_token: "<40 char token>"} }

      it { Octokit::Client.should have_received(:new).with(auth_params) }
    end

    context "with .netrc" do
      let(:auth_params) { {netrc: true} }

      it { Octokit::Client.should have_received(:new).with(auth_params) }
    end

    context "with Application authentication" do
      let(:auth_params) { {client_id: "<20 char id>", client_secret: "<40 char secret>"} }

      it { Octokit::Client.should have_received(:new).with(auth_params) }
    end
  end

  describe "#exists?", :vcr do
    context "valid GitHub account" do
      it "returns true" do
        expect(connection.exists?("winston")).to be_true
      end
    end

    context "invalid GitHUb account" do
      it "returns false" do
        expect(connection.exists?("thisisaverylongloginnamethatdontexist")).to be_false
      end
    end
  end

  describe "#details_for", :vcr do
    let(:expected) do
      contents = JSON.parse(File.read(File.join(Dir.pwd, "spec", "fixtures", file)))
      # stringify keys
      contents.inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }
    end

    context "user" do
      let(:file) { "github_user.json" }
      it { expect(connection.details_for("winston")).to eq(expected) }
    end

    context "organization" do
      let(:file) { "github_organization.json" }
      it { expect(connection.details_for("neo")).to eq(expected) }
    end
  end

  describe "#repositories_for", :vcr do
    before { connection.stub(:gemfile_for) { nil } }

    context "user" do
      it "returns an array of Gigest::GithubRepo" do
        Gigest::GithubRepo.stub(:new)
        expect(connection.repositories_for("winston")).to be_kind_of Array
        Gigest::GithubRepo.should have_received(:new).at_least(20).times
      end
    end

    context "organization" do
      it "returns an array of Gigest::GithubRepo" do
        Gigest::GithubRepo.stub(:new)
        expect(connection.repositories_for("neo")).to be_kind_of Array
        Gigest::GithubRepo.should have_received(:new).at_least(40).times
      end
    end
  end

  describe "#gemfile_for", :vcr do
  	context "when Gemfile exists" do
  		let(:repository_name) { "winston/google_visualr_app" }
  		let(:expected) 	      { File.read(File.join(Dir.pwd, "spec", "fixtures", "Gemfile")) }

	  	it "returns the Gemfile contents" do
			 expect(connection.gemfile_for(repository_name)).to eq expected
	  	end
  	end

  	context "when Gemfile does not exist" do
			let(:repository_name) { "winston/dotfiles" }

	  	it "returns nil" do
				expect(connection.gemfile_for(repository_name)).to be_nil
	  	end
  	end
  end
end
