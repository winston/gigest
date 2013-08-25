require 'spec_helper'

describe Gigest::Analytics do
  context "authentication" do
    context "with username and password" do
      subject(:analytics) { Gigest::Analytics.new() }

      it "passes params to Ockokit" do
      end
    end

    context "with oauth" do
      subject(:analytics) { Gigest::Analytics.new() }

      it "passes params to Ockokit" do
      end
    end

    context "with .netrc" do
      subject(:analytics) { Gigest::Analytics.new() }

      it "passes params to Ockokit" do
      end
    end

    context "with application" do
      subject(:analytics) { Gigest::Analytics.new() }

      it "passes params to Ockokit" do
      end
    end
  end

  describe "#process_for" do
    subject(:analytics) { Gigest::Analytics.new() }

    it "returns a summary" do
      analytics.process_for("account_name")
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
