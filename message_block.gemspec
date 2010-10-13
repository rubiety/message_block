Gem::Specification.new do |s|
  s.name        = "message_block"
  s.version     = "1.0"
  s.author      = "Ben Hughes"
  s.email       = "ben@railsgarden.com"
  s.homepage    = "http://github.com/rubiety/message_block"
  s.summary     = "Flash message and error_messages_for handling with a common interface."
  s.description = "Implements the common view pattern by which a list of messages are shown at the top, often a combination of flash messages and ActiveRecord validation issues on one or more models."
  
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  
  s.add_dependency("activesupport", [">= 2.2.1"])
  s.add_dependency("actionpack", [">= 2.2.1"])
end
