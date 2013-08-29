require 'spec_helper'

describe Gigest::Analytics do
  let(:analytics) { Gigest::Analytics.new(access_token: ENV["GIGEST_TEST_GITHUB_TOKEN"]) }

  context "#initialize" do
    let(:auth_params) { {login: "username", password: "password"} }

    it "instantiates a connection" do
      Gigest::GithubConnection.stub(:new)
      Gigest::Analytics.new(auth_params)
      Gigest::GithubConnection.should have_received(:new).with(auth_params)
    end
  end

  describe "#process_for" do
    let(:account_details)           { {name: "naruto", company: "konoha"} }
    let(:repositories)              { [repo1, repo2] }
    let(:repositories_with_gemfile) { [repo1] }

    let(:repo1) { double(:repo1, has_gemfile?: true)  }
    let(:repo2) { double(:repo2, has_gemfile?: false) }

    before do
      Gigest::GithubConnection.any_instance.stub(:details_for).with(anything, anything) { account_details }
      Gigest::GithubConnection.any_instance.stub(:repositories_for).with(anything, anything) { repositories }
      analytics.process_for("somebody")
    end

    it "inits account_details" do
      expect(analytics.account_details).to eq(account_details)
    end

    it "inits repositories" do
      expect(analytics.repositories).to eq(repositories)
    end

    it "inits repositories with gemfile" do
      expect(analytics.repositories_with_gemfile).to eq(repositories_with_gemfile)
    end
  end

  describe "#summary", :vcr do
    let(:expected) { JSON.parse File.read(File.join(Dir.pwd, "spec", "fixtures", "summary.json")) }

    context "when repositories exist" do
      before { analytics.process_for("winston") }

      it "generates a summary report" do
        expect(analytics.summary).to eq(expected)
      end
    end

    context "when repositories don't exist" do
      it "raises an error" do
        expect { analytics.summary }.to raise_error
      end
    end
  end

  describe "#statistics", :vcr do
    let(:expected) do
      contents = JSON.parse(File.read(File.join(Dir.pwd, "spec", "fixtures", "statistics.json")))
      contents.map do |row|
        row.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      end
    end

    context "when repositories exist" do
      before { analytics.process_for("winston") }

      it "generates a summary report" do
        expect(analytics.statistics).to eq(expected)
      end
    end

    context "when repositories don't exist" do
      it "raises an error" do
        expect { analytics.statistics }.to raise_error
      end
    end
  end
end
