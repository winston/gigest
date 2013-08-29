module Gigest
  class GithubConnection
    def initialize(auth_params)
      @connection = Octokit::Client.new(auth_params)
    end

    def repositories_for(account=nil, type=:user)
      all_repositories  = []

      page = 0
      loop do
        repositories = @connection.send(repository_method(type), account, page: page+=1)
        break if repositories.empty?

        all_repositories += repositories.map { |repository| GithubRepo.new(repository, gemfile_for(repository.full_name)) }
      end

      all_repositories
    end

    def gemfile_for(repository_name)
      decode(file_blob(repository_name, "Gemfile"))
    rescue Octokit::NotFound
      nil
    end

    private

    def repository_method(type)
      type == :org ? :organization_repositories : :repositories
    end

    def decode(blob)
      Base64.decode64(blob)
    end

    def file_blob(repository_name, file)
      @connection.contents(repository_name, path: file).content
    end
  end
end
