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

  describe "#analyzable?" do
    it "delegates to connection" do
      Gigest::GithubConnection.any_instance.should_receive(:exists?).with("winston")

      analytics.analyzable?("winston")
    end
  end

  describe "#process_for" do
    let(:account_details) { {name: "naruto", company: "konoha"} }
    let(:repositories) { [repo1, repo2] }
    let(:expected)     { [repo2] }
    let(:repo1) { double(:repo1, has_gemfile?: false) }
    let(:repo2) { double(:repo2, has_gemfile?: true) }

    before do
      Gigest::GithubConnection.any_instance.stub(:details_for)      { account_details }
      Gigest::GithubConnection.any_instance.stub(:repositories_for) { repositories }
      analytics.process_for("somebody")
    end

    it "inits account_details" do
      expect(analytics.account_details).to eq(account_details)
    end

    it "inits repositories" do
      expect(analytics.all_repositories).to eq(repositories)
    end

    it "inits repositories_with_gemfile" do
      expect(analytics.all_repositories_with_gemfile).to eq(expected)
    end
  end

  describe "#source_repositories" do
    let(:repositories) { [repo1, repo2] }
    let(:expected)     { [repo1] }
    let(:repo1) { double(:repo1, fork?: false) }
    let(:repo2) { double(:repo2, fork?: true) }

    before { analytics.stub(:all_repositories) { repositories } }

    it { expect(analytics.source_repositories).to eq expected }
  end

  describe "#source_repositories_with_gemfile" do
    let(:repositories) { [repo1, repo2] }
    let(:expected)     { [repo2] }
    let(:repo1) { double(:repo1, has_gemfile?: false) }
    let(:repo2) { double(:repo2, has_gemfile?: true) }

    before { analytics.stub(:source_repositories) { repositories } }

    it { expect(analytics.source_repositories_with_gemfile).to eq expected }
  end

  describe "#fork_repositories" do
    let(:repositories) { [repo1, repo2] }
    let(:expected)     { [repo2] }
    let(:repo1) { double(:repo1, fork?: false) }
    let(:repo2) { double(:repo2, fork?: true) }

    before { analytics.stub(:all_repositories) { repositories } }

    it { expect(analytics.fork_repositories).to eq expected }
  end

  describe "#fork_repositories_with_gemfile" do
    let(:repositories) { [repo1, repo2] }
    let(:expected)     { [repo2] }
    let(:repo1) { double(:repo1, has_gemfile?: false) }
    let(:repo2) { double(:repo2, has_gemfile?: true) }

    before { analytics.stub(:fork_repositories) { repositories } }

    it { expect(analytics.fork_repositories_with_gemfile).to eq expected }
  end

  describe "#summary", :vcr do
    context "when repositories exist" do
      before { analytics.process_for("winston") }

      context "for all repositories" do
        let(:expected) { JSON.parse(File.read(File.join(Dir.pwd, "spec", "fixtures", "summary_all.json"))) }

        it { expect(analytics.summary).to eq(expected) }
      end

      context "for source repositories only" do
        let(:expected) { JSON.parse(File.read(File.join(Dir.pwd, "spec", "fixtures", "summary_source.json"))) }

        it { expect(analytics.summary(:source)).to eq(expected) }
      end

      context "for fork repositories only" do
        let(:expected) { JSON.parse(File.read(File.join(Dir.pwd, "spec", "fixtures", "summary_fork.json"))) }

        it { expect(analytics.summary(:fork)).to eq(expected) }
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
      contents = JSON.parse(File.read(File.join(Dir.pwd, "spec", "fixtures", file)))
      # symbolize keys
      contents.map { |row| row.inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo } }
    end

    context "when repositories exist" do
      before { analytics.process_for("winston") }

      context "for all repositories" do
        let(:file) { "statistics_all.json" }

        it { expect(analytics.statistics).to eq(expected) }
      end

      context "for source repositories only" do
        let(:file) { "statistics_source.json" }

        it { expect(analytics.statistics(:source)).to eq(expected) }
      end

      context "for fork repositories only" do
        let(:file) { "statistics_fork.json" }

        it { expect(analytics.statistics(:fork)).to eq(expected) }
      end
    end

    context "when repositories don't exist" do
      it "raises an error" do
        expect { analytics.statistics }.to raise_error
      end
    end
  end
end
