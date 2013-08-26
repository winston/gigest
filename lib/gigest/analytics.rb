module Gigest
  class Analytics

    def initialize(auth_params={})
      @connection = GithubConnection.new(auth_params)      
    end  

    def process_for(account)
      raise "Gigest::Analytics#process_for requires an account name!" if account.nil?
    end


    # def initialize(account, api_token=DEFAULT_API_TOKEN)
    #   @account   = account
    #   @api_token = api_token

    #   @gems = {}
    # end

    def run
      @github_account = GithubAccount.new(@account, @api_token)
      @github_account.repositories[1..10].each do |repository|
        begin
          gemfile = repository.gemfile
          @gems[repository.name] = analyze(gemfile)
        rescue Octokit::NotFound
        end
      end
      puts summary.inspect
    end

    def analyze(gemfile)
      gems = gemfile.split("\n").map do |gem|
        if gem.start_with?("#")
          nil
        else
          regex_match = gem.match(/(?<sdq>['"])(?<name>[a-zA-Z0-9\-_]+)\k<sdq>/)
          regex_match.nil? ? nil : regex_match[:name]
        end
      end.compact
    end

    def summary
      # Total Repos
      # Repos with Gemfile
      # Gems and Count
      # Gems

      summary = Hash.new(0)
      @gems.values.flatten.each { |gem| summary[gem] += 1 }

      {
        repositories: @github_account.repositories.size,
        gemfiles: @gems.size,
        summary: summary,
        gems: @gems
      }
    end
  end
end

# Generated with http://rubydoc.info/gems/octokit/Octokit/Client/Authorizations#create_authorization-instance_method
# Gigest::Report.new("neo", "8b64296f202e33561818ffbd5274747013a74176").run
