require "base64"
require "octokit"

lib_path = File.dirname(__FILE__)
require "#{lib_path}/gigest/version"

require "#{lib_path}/gigest/analytics"
require "#{lib_path}/gigest/github/github_connection"
require "#{lib_path}/gigest/github/github_repo"
