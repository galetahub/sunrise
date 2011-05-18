# encoding: utf-8
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the sunrise plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the sunrise plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Sunrise'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "sunrise"
    s.version = File.open(File.dirname(__FILE__) + '/VERSION', 'r').read.strip
    s.summary = "Rails CMS"
    s.description = "Sunrise is a Aimbulance CMS"
    s.email = "galeta.igor@gmail.com"
    s.homepage = "https://github.com/galetahub/sunrise"
    s.authors = ["Igor Galeta", "Pavlo Galeta"]
    s.files =  FileList["[A-Z]*", "{lib}/**/*"]
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
