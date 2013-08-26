module Gigest
  class GithubConnection
    def initialize(auth_params)
      @connection = Octokit::Client.new(auth_params)
    end

    def repositories_for(account=nil)
      @connection.repositories(account).map do |repository|
        GithubRepo.new(repository, gemfile_for(repository))
      end
    end

    def gemfile_for(repository)
      decode(file_blob(repository, "Gemfile"))
    rescue Octokit::NotFound
      nil
    end

    private

    def decode(blob)
      Base64.decode64(blob)
    end

    def file_blob(repository, file)
      @connection.contents(repository.full_name, path: file).content
    end
  end
end
