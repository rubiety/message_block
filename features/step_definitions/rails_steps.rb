Given "I have a rails application" do
  steps %{
    Given I generate a rails application
    And this plugin is available in the Gemfile
    And I run "bundle install"
    And I run "rm public/index.html"
    And I run "rails g scaffold model name:string"
    And I setup the database
  }
end

Given %r{I generate a rails application} do
  FileUtils.rm_rf(TEMP_ROOT)
  FileUtils.mkdir_p(TEMP_ROOT)
  
  Dir.chdir(TEMP_ROOT) do
    `rails new #{APP_NAME}`
  end
end

When %r{this plugin is available in the Gemfile} do
  When %{I append the following to "Gemfile"}, %{gem "message_block", :path => "#{PROJECT_ROOT}"}
  When %{I append the following to "Gemfile"}, %{
    group :test do
      gem "capybara"
      gem "rspec"
    end
  }
end

When %r{I setup the database} do
  When %{I run "bundle exec rake db:create db:migrate --trace"}
end

When %r{the rails application is running} do
  Dir.chdir(CUC_RAILS_ROOT) do
    require "config/environment"
    require "capybara/rails"
  end
end

When %r{I save the following as "([^"]*)"} do |path, string|
  FileUtils.mkdir_p(File.join(CUC_RAILS_ROOT, File.dirname(path)))
  File.open(File.join(CUC_RAILS_ROOT, path), 'w') { |file| file.write(string) }
end

When %r{I append the following to "([^"]*)"} do |path, string|
  FileUtils.mkdir_p(File.join(CUC_RAILS_ROOT, File.dirname(path)))
  File.open(File.join(CUC_RAILS_ROOT, path), 'a+') { |file| file.write(string) }
end

When %r{I run "([^"]*)"} do |command|
  Dir.chdir(CUC_RAILS_ROOT) do
    `#{command}`
  end
end

Then %r{^the file "([^"]*)" should exist} do |file|
  File.should be_exist(File.join(CUC_RAILS_ROOT, file))
end
