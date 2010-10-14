# PROBLEMS: 
# Would really like to do this here, and Gemfile is defined, but unfortunately if we do a require here 
# it will prevent the test_app's Gemfile from being required later when we try to invoke the application.
# Have not found a solution, may require a bundler patch to "unload" bundler and load another within the same
# ruby intance.
# 
# require "bundler"
# Bundler.require(:default, :development)

require "rspec/expectations"
require "capybara/cucumber"

begin
  require "launchy"
rescue LoadError
end