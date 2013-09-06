module Gigest
  class GithubRepo
    def initialize(repository, gemfile)
      @repository = repository
      @gemfile    = gemfile
    end

    def name
      @repository.full_name
    end

    def private?
      @repository.private
    end

    def fork?
      @repository.fork
    end

    def has_gemfile?
      !@gemfile.nil?
    end

    def gems
      return [] if !has_gemfile?

      @gems ||= process_gemfile
    end

    private

    def process_gemfile
      @gemfile.split("\n").map do |string|
        string.start_with?("#") ? nil : find_gem_name(string)
      end.compact
    end

    def find_gem_name(string)
      regex_match = string.match(/gem\s+(?<sdq>['"])(?<name>[a-zA-Z0-9\-_]+)\k<sdq>/)
      regex_match.nil? ? nil : regex_match[:name]
    end
  end
end
