require "bundler/gem_tasks"

# RSpec Tasks
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts 		= ['--options', '.rspec']
  t.fail_on_error 	= false
end

task :default => :spec
