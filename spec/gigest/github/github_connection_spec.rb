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

  describe "#repositories", :vcr do
    before do
      Gigest::GithubRepo.stub(:new)
      Gigest::GithubConnection.stub(:gemfile_for) { nil }
    end

  	it "returns an array of Gigest::GithubRepo" do
			repositories = connection.repositories_for("winston") 	

      Gigest::GithubRepo.should have_received(:new).at_least(20).times
      expect(repositories).to be_kind_of Array
  	end
  end

  describe "#gemfile_for", :vcr do
  	let(:repository) { double(:repository, full_name: full_name)}

  	context "when Gemfile exists" do
  		let(:full_name) { "winston/google_visualr_app" }
  		let(:expected) 	{ File.read(File.join(Dir.pwd, "spec", "fixtures", "gemfile_for_google_visualr_app")) }

	  	it "returns the Gemfile contents" do
			 expect(connection.gemfile_for(repository)).to eq expected
	  	end
  	end

  	context "when Gemfile does not exist" do
			let(:full_name) { "winston/dotfiles" }

	  	it "returns nil" do
				expect(connection.gemfile_for(repository)).to be_nil
	  	end
  	end
  end
end
