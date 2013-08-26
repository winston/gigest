module Gigest
  class Analytics
    attr_reader :repositories, :repositories_with_gemfile

    def initialize(auth_params={})
      @connection = GithubConnection.new(auth_params)
    end

    def process_for(account=nil, type=:user)
      @repositories              = @connection.repositories_for(account)
      @repositories_with_gemfile = @repositories.select(&:has_gemfile?)
    end

    # Returns summary
    # {
    #   gem1: [repo1, repo2],
    #   gem2: [repo1, repo2]
    # }
    def summary
      raise "Please specify GitHub account to analyse by invoking #process_for(account) method first!" if @repositories.nil?

      @repositories_with_gemfile.inject({}) do |summary, repository|
        repository.gems.each do |gem|
          summary[gem] ||= []
          summary[gem] << repository.name unless summary[gem].include?(repository.name)
        end

        summary
      end
    end

    # Returns statistic (sorted desc)
    # [
    #   [gem1, 2],
    #   [gem2, 1]
    # ]
    def statistics
      summary.inject({}) do |summary, (gem, repos)|
        summary[gem] = repos.count
        summary
      end
      .sort_by { |gem, count| count }.reverse
    end
  end
end
