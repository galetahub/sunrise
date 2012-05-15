# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sunrise/version"

Gem::Specification.new do |s|
  s.name = "sunrise-cms"
  s.version = Sunrise::VERSION.dup
  s.platform = Gem::Platform::RUBY 
  s.summary = "Rails CMS"
  s.description = "Sunrise is a Aimbulance CMS"
  s.authors = ["Igor Galeta", "Pavlo Galeta"]
  s.email = "galeta.igor@gmail.com"
  s.rubyforge_project = "sunrise-cms"
  s.homepage = "https://github.com/galetahub/sunrise"
  
  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc", "CHANGELOG.rdoc"]
  s.test_files = Dir["{spec}/**/*"]
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc"]
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("rails", "~> 3.2.0")
  s.add_runtime_dependency("kaminari", "~> 0.13.0")
  s.add_runtime_dependency("simple_form", "~> 2.0.2")
  s.add_runtime_dependency("jbuilder", "~> 0.4.0")
  
  s.add_runtime_dependency("awesome_nested_set", "~> 2.1.3")
  s.add_runtime_dependency("mime-types", "~> 1.18")
  s.add_runtime_dependency("mini_magick", "~> 3.4")
  s.add_runtime_dependency("carrierwave", "~> 0.6.2")
  s.add_runtime_dependency("cancan", "~> 1.6.7")
  s.add_runtime_dependency("cancan_namespace", "~> 0.1.3")
  s.add_runtime_dependency("friendly_id", "~> 4.0.5")
  s.add_runtime_dependency("galetahub-enum_field", "~> 0.2.0")
  s.add_runtime_dependency("acts_as_audited", "~> 2.1.0")
  s.add_runtime_dependency("page_parts", "~> 0.0.3")
  s.add_runtime_dependency("meta_manager", "~> 0.0.5")
  s.add_runtime_dependency("progressbar", "~> 0.11.0")
  
  s.add_development_dependency("rspec-rails", "~> 2.10.1")
  s.add_development_dependency("generator_spec", "~> 0.8.5")
  s.add_development_dependency("mysql2", "~> 0.3.11")
  s.add_development_dependency("database_cleaner", ">= 0")
  s.add_development_dependency("factory_girl", "~> 3.3.0")
  s.add_development_dependency("capybara", "~> 1.1.2")
end
