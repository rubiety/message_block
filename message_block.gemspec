# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{message_block}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Hughes"]
  s.date = %q{2009-01-16}
  s.description = %q{Handle multiple flash messages and ActiveRecord validation errors with ease.}
  s.email = %q{ben@railsgarden.com}
  s.extra_rdoc_files = ["CHANGELOG", "lib/message_block/helpers.rb", "lib/message_block.rb", "README.rdoc"]
  s.files = ["assets/images/back.gif", "assets/images/back_m.gif", "assets/images/confirmation.gif", "assets/images/confirmation_m.gif", "assets/images/error.gif", "assets/images/error_m.gif", "assets/images/info.gif", "assets/images/info_m.gif", "assets/images/warn.gif", "assets/images/warn_m.gif", "assets/stylesheets/message_block.css", "CHANGELOG", "init.rb", "install.rb", "lib/message_block/helpers.rb", "lib/message_block.rb", "MIT-LICENSE", "Rakefile", "README.rdoc", "test/message_block_helper_test.rb", "Manifest", "message_block.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/railsgarden/message_block}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Message_block", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{message_block}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Handle multiple flash messages and ActiveRecord validation errors with ease.}
  s.test_files = ["test/message_block_helper_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
