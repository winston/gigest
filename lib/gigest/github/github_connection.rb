module Gigest
  class GithubConnection
    def initialize(auth_params)
      @connection = Octokit::Client.new(auth_params)
    end

    def details_for(account=nil)
      details = @connection.user(account)

      {
        name: details[:name],
        type: details[:type],
        avatar_url: details._rels[:avatar].href,
        company: details[:company],
        location: details[:location],
        html_url: details._rels[:html].href
      }
    end

    def repositories_for(account=nil)
      all_repositories  = []

      page = 0
      loop do
        repositories = @connection.repositories(account, page: page+=1)
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

    def decode(blob)
      Base64.decode64(blob)
    end

    def file_blob(repository_name, file)
      @connection.contents(repository_name, path: file).content
    end
  end
end
