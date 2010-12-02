Given %r{^I have a rails application$} do
  Given %{I ensure a rails application is generated}
  And %{the Gemfile is configured for testing}
  And %{the Gemfile contains this gem}
  And %{I run "bundle install"}
end

Given %r{^I generate a rails application$} do
  FileUtils.rm_rf(Cukigem.temp_root)
  FileUtils.mkdir_p(Cukigem.temp_root)
  
  Dir.chdir(Cukigem.temp_root) do
    `rails new #{Cukigem.application_name}`
  end

  Given "I turn off class caching in the rails application"
end

Given %r{^I turn off class caching in the rails application} do
  Dir.chdir(Cukigem.app_root) do
    File.open("config/environments/test.rb", "r+") do |f|
      f.write f.read.gsub!(/config.cache_classes.*$/, "config.cache_classes = false")
    end
  end
end

Given %r{^I ensure a rails application is generated$} do
  if File.exists?(Cukigem.app_root)
    Given "I reset the rails application"
  else
    Given "I generate a rails application"
  end
end

Given %r{^I reset the rails application$} do
  if File.exists?(Cukigem.app_root)
    Dir.chdir(Cukigem.app_root) do
      Cukigem.paths_to_clear.map {|f| Dir[f] }.flatten.each do |dir|
        FileUtils.rm_rf(dir) if File.exists?(dir)
      end
      
      Given "I reset the routes file"
      Given "I define an application controller"
      Given "I reset the Gemfile"
    end
  end
end

Given %r{^I reset the routes file$} do
  Given %{I save the following as "config/routes.rb"}, %{RailsApp::Application.routes.draw do\nend}
end

Given %r{^I define an application controller$} do
  Given %{I save the following as "app/controllers/application_controller.rb"}, %{class ApplicationController < ActionController::Base\nend}
end

Given %r{^I reset the Gemfile$} do
  Given %{I save the following as "Gemfile"}, %{
    source 'http://rubygems.org'
    gem 'rails', '3.0.1'
    gem 'sqlite3-ruby', :require => 'sqlite3'
  }
end

When %r{^the Gemfile is configured for testing$} do
  When %{I append the following to "Gemfile"}, %{
    group :test do
      gem "capybara"
      gem "rspec"
    end
  }
end

When %r{^the Gemfile contains this gem$} do
  When %{I append the following to "Gemfile"}, %{gem "#{File.basename(Cukigem.project_root)}", :path => "#{Cukigem.project_root}"}
end

When %r{^I setup the database$} do
  When %{I run "bundle exec rake db:create db:migrate --trace RAILS_ENV=test"}
end


When %r{^I start the rails application$} do
  Dir.chdir(Cukigem.project_root)
  Dir.chdir(Cukigem.app_root) do
    ENV["RAILS_ENV"] = "test"
    require "config/environment.rb"
    
    if Object.const_defined?(:Capybara)
      require "capybara/rails"
    elsif Object.const_defined?(:Webrat)
      require "webrat/rails"
    end

    ActiveRecord::Base.clear_all_connections!
  end
end

When %r{^I start the rails application at "([^"]*)"$} do |path|
  Dir.chdir(Cukigem.project_root)
  Dir.chdir(path) do
    ENV["RAILS_ENV"] = "test"
    require "config/environment.rb"
    
    if Object.const_defined?(:Capybara)
      require "capybara/rails"
    elsif Object.const_defined?(:Webrat)
      require "webrat/rails"
    end
  end
end


When %r{^I save the following as "([^"]*)"} do |path, string|
  FileUtils.mkdir_p(File.join(Cukigem.app_root, File.dirname(path)))
  File.open(File.join(Cukigem.app_root, path), "w") do |file|
    file.write(string)
  end
end

When %r{^I append the following to "([^"]*)"} do |path, string|
  FileUtils.mkdir_p(File.join(Cukigem.app_root, File.dirname(path)))
  File.open(File.join(Cukigem.app_root, path), "a+") do |file|
    file.write(string)
  end
end

When %r{^I run "([^"]*)"$} do |command|
  Dir.chdir(Cukigem.app_root) do
    `#{command}`
  end
end

Then %r{^the file "([^"]*)" should exist$} do |file|
  File.should be_exist(File.join(Cukigem.app_root, file))
end
