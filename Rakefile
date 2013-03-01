require 'rubygems'
require 'bundler/setup'

require 'rake'
require 'appraisal'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rdoc/task'

Bundler::GemHelper.install_tasks

desc 'Default: run unit tests.'
task :default => [:clean, :test]

desc "Run Specs"
RSpec::Core::RakeTask.new(:spec) do |t|
end

task :test => :spec

desc 'Default: run unit tests.'
task :default => [:clean, :all]

desc 'Test the paperclip plugin under all supported Rails versions.'
task :all do |t|
  if ENV['BUNDLE_GEMFILE']
    exec('rake test')
  else
    Rake::Task["appraisal:install"].execute
    exec('rake appraisal test')
  end
end

desc "Clean up files."
task :clean do |t|
  FileUtils.rm_rf "tmp"
  Dir.glob("message_block-*.gem").each {|f| FileUtils.rm f }
end

desc "Generate documentation for the plugin."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "message_block"
  rdoc.options << "--line-numbers" << "--inline-source"
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rake"].sort.each { |ext| load ext }


