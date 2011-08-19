# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
version = File.open(File.dirname(__FILE__) + '/VERSION', 'r').read.strip

Gem::Specification.new do |s|
  s.name = "sunrise-cms"
  s.version = version
  s.platform = Gem::Platform::RUBY 
  s.summary = "Rails CMS"
  s.description = "Sunrise is a Aimbulance CMS"
  s.authors = ["Igor Galeta", "Pavlo Galeta"]
  s.email = "galeta.igor@gmail.com"
  s.rubyforge_project = "sunrise-cms"
  s.homepage = "https://github.com/galetahub/sunrise"
  
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "VERSION", "README.rdoc"]
  s.test_files = Dir["{spec}/**/*"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency(%q<sunrise-core>, ["= #{version}"])
  s.add_runtime_dependency(%q<sunrise-scaffold>, ["= #{version}"])
end
