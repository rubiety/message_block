# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "message_block/version"

Gem::Specification.new do |s|
  s.name        = "message_block"
  s.version     = MessageBlock::VERSION
  s.author      = "Ben Hughes"
  s.email       = "ben@railsgarden.com"
  s.homepage    = "http://github.com/rubiety/message_block"
  s.summary     = "Flash message and error_messages_for handling with a common interface."
  s.description = "Implements the common view pattern by which a list of messages are shown at the top, often a combination of flash messages and ActiveRecord validation issues on one or more models."
  
  s.files        = Dir["{lib,spec,assets,rails}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  
  s.add_dependency("rails", [">= 3.0.0"])
  s.add_development_dependency("rspec", ["~> 2.0"])
  s.add_development_dependency("cucumber", ["~> 0.9.2"])
  s.add_development_dependency("capybara", ["~> 0.3.9"])
  s.add_development_dependency("sqlite3-ruby", ["~> 1.3.1"])
end
