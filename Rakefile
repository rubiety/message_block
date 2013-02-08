require 'rubygems'
require 'rake'
require 'rdoc/task'

require 'rubygems'
require 'bundler/setup'

require 'rake'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Default: run unit tests.'
task :default => [:clean, :test]

desc "Run Specs"
RSpec::Core::RakeTask.new(:spec) do |t|
end

task :test => :spec

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


