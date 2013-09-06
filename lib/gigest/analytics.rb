module Gigest
  class Analytics
    attr_reader :account_details

    def initialize(auth_params={})
      @connection = GithubConnection.new(auth_params)
    end

    def analyzable?(account)
      @connection.exists?(account)
    end

    def process_for(account)
      @account_details = @connection.details_for(account)
      @repositories    = @connection.repositories_for(account)
    end

    def all_repositories
      @repositories
    end

    def all_repositories_with_gemfile
      all_repositories.select(&:has_gemfile?)
    end

    def source_repositories
      all_repositories.reject(&:fork?)
    end

    def source_repositories_with_gemfile
      source_repositories.select(&:has_gemfile?)
    end

    def fork_repositories
      all_repositories.select(&:fork?)
    end

    def fork_repositories_with_gemfile
      fork_repositories.select(&:has_gemfile?)
    end

    # Returns summary
    # Assuming GitHub user/org only has repo1 and repo2
    # {
    #   gem1: [repo1, repo2],
    #   gem2: [repo1, repo2]
    # }
    def summary(type=:all)
      raise "Please specify GitHub account to analyse by invoking #process_for(account) method first!" if all_repositories.nil?

      get_repositories(type).reduce({}) do |summary, repository|
        repository.gems.each do |gem|
          summary[gem] ||= []
          summary[gem] << repository.name unless summary[gem].include?(repository.name)
        end
        summary
      end
    end

    # Returns statistic (sorted desc by count)
    # Assuming GitHub user/org only has repo1 and repo2
    # [
    #   {gem_name: gem1, repositories: ["repo1", "repo2"], count: 2, percentage: 100.0},
    #   {gem_name: gem2, repositories: ["repo1"], count: 1, percentage: 50.0}
    # ]
    def statistics(type=:all)
      raise "Please specify GitHub account to analyse by invoking #process_for(account) method first!" if all_repositories.nil?

      repos_summary   = summary(type)
      repo_type_count = get_repositories(type).count

      repos_summary.map do |gem, repos|
        {
          gem_name: gem,
          repositories: repos,
          count: repos.count,
          percentage: percentage(repos.count, repo_type_count)
        }
      end
      .sort_by { |statistic| statistic[:count] }.reverse
    end

    private

    def get_repositories(type)
      send("#{type}_repositories_with_gemfile")
    end

    def percentage(numerator, denominator)
      (numerator.to_f / denominator.to_f * 100).round(2)
    end
  end
end
