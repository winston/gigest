module Gigest
  class Analytics
    attr_reader :account_details, :repositories, :repositories_with_gemfile

    def initialize(auth_params={})
      @connection = GithubConnection.new(auth_params)
    end

    def process_for(account=nil)
      @account_details           = @connection.details_for(account)
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
    # Assuming GitHub user/org only has repo1 and repo2
    # [
    #   {gem_name: gem1, repositories: ["repo1", "repo2"], count: 2, percentage: 100.0},
    #   {gem_name: gem2, repositories: ["repo1"], count: 1, percentage: 50.0}
    # ]
    def statistics
      summary.map do |gem_name, repositories|
        {
          gem_name: gem_name,
          repositories: repositories,
          count: repositories.count,
          percentage: percentage(repositories.count, @repositories_with_gemfile.count)
        }
      end
      .sort_by { |statistic| statistic[:count] }.reverse
    end

    private

    def percentage(numerator, denominator)
      (numerator.to_f / denominator.to_f * 100).round(2)
    end
  end
end
