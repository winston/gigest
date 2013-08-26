require 'spec_helper'

describe Gigest::GithubRepo do
	let(:github_repo) { double(:repository, full_name: "winston") }
	let(:gemfile) 		{ "gemfile contents" }

	let(:gigest_repo) { Gigest::GithubRepo.new(github_repo, gemfile) }

	describe "#initialize" do
		it "contains instance variables" do
			expect(gigest_repo.instance_variable_get(:@repository)).to eq github_repo
	    expect(gigest_repo.instance_variable_get(:@gemfile)).to 	 eq gemfile
		end
	end

	describe "#name" do
		it "returns name of the repository" do
			expect(gigest_repo.name).to eq github_repo.full_name
		end
	end

	describe "#gems" do
		context "gemfile is nil" do
			let(:gemfile) { nil }

			it "returns empty array" do
				expect(gigest_repo.gems).to eq []
			end
		end

		context "gemfile is not nil" do
  		let(:gemfile) { File.read(File.join(Dir.pwd, "spec", "fixtures", "Gemfile")) }

  		it "returns an array of gems" do
  			expect(gigest_repo.gems).to eq %w(rails google_visualr compass-rails sass-rails uglifier heroku)
  		end
		end
	end
end
