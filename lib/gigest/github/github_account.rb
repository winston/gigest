require 'octokit'

class GithubAccount
  def initialize(account, api_token)
    @account   = account
    @api_token = api_token
    connection
  end

  def connection
    @connection   ||= Octokit::Client.new(oauth_token: @api_token)
  end

  def repositories
    @repositories ||= connection.repositories(@account).map do |repository|
      GithubRepo.new(connection, repository)
    end
  end
end
