class GithubRepo
  def initialize(connection, repository)
    @connection = connection
    @repository = repository
  end

  def name
    @repository.full_name
  end

  def file_blob(file)
    @connection.contents(name, path: file).content
  end

  def gemfile
    decode(file_blob("Gemfile"))
  end

  private

  def decode(blob)
    Base64.decode64(blob)
  end
end
