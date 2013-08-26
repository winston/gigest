module Gigest
  class GithubRepo
    attr_reader :gemfile

    def initialize(repository, gemfile)
      @repository = repository
      @gemfile    = gemfile
    end

    def name
      @repository.full_name
    end
  end
end
