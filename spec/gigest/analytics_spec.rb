require 'spec_helper'

describe Gigest::Analytics do
  context "#initialize" do
    let(:auth_params) { {login: "username", password: "password"} }

    it "instantiates a connection" do
      Gigest::GithubConnection.stub(:new)
      Gigest::Analytics.new(auth_params)
      Gigest::GithubConnection.should have_received(:new).with(auth_params)
    end
  end

  describe "#process_for" do
    subject(:analytics) { Gigest::Analytics.new(access_token: ENV["GIGEST_TEST_GITHUB_TOKEN"]) }

    context "without an account" do
      it "raises an exception" do
        expect { analytics.process_for(nil) }.to raise_error
      end
    end

    it "returns a summary" do
      analytics.process_for("neo")
    end
  end


  # subject(:analytics) { Gigest::Analytics.new("name", "oauth_token") }

  # it "initializes" do
  #   analytics.instance_variable_get(:@account).should   == "name"
  #   analytics.instance_variable_get(:@api_token).should == "oauth_token"
  #   analytics.instance_variable_get(:@gems).should be_empty
  # end

  # it "returns a summary" do
  #   analytics.run
  # end
end
