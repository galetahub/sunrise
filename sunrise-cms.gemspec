# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sunrise/version"

Gem::Specification.new do |s|
  s.name = "sunrise-cms"
  s.version = Sunrise::VERSION.dup
  s.platform = Gem::Platform::RUBY 
  s.summary = "Rails CMS"
  s.description = "Sunrise is a Open Source CMS"
  s.authors = ["Igor Galeta", "Pavlo Galeta"]
  s.email = "galeta.igor@gmail.com"
  s.rubyforge_project = "sunrise-cms"
  s.homepage = "https://github.com/galetahub/sunrise"
  
  s.files = Dir["{app,config,db,lib,vendor/assets}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md", "CHANGELOG.rdoc"]
  s.test_files = Dir["{spec}/**/*"]
  s.extra_rdoc_files = ["README.md", "CHANGELOG.rdoc"]
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("rails", "~> 4.0.0")
  s.add_runtime_dependency("kaminari")
  s.add_runtime_dependency("simple_form")
  s.add_runtime_dependency("jbuilder")
  
  s.add_runtime_dependency("mime-types")
  s.add_runtime_dependency("mini_magick")
  s.add_runtime_dependency("carrierwave")
  s.add_runtime_dependency("cancan")
  s.add_runtime_dependency("cancan_namespace")
  s.add_runtime_dependency("galetahub-enum_field")
  s.add_runtime_dependency("progressbar")
  s.add_runtime_dependency("rails-uploader")
  s.add_runtime_dependency("babosa")
  s.add_runtime_dependency("jquery-ui-rails")
  s.add_runtime_dependency("page_parts", ">= 0.1.3")
  s.add_runtime_dependency("meta_manager", ">= 0.2.0")
  s.add_runtime_dependency("public_activity", ">= 1.0.0")
  s.add_runtime_dependency("rails-settings-cached", ">= 0.4.0")
  
  s.add_development_dependency("rspec-rails")
  s.add_development_dependency("generator_spec")
  s.add_development_dependency("mysql2")
  s.add_development_dependency("database_cleaner")
  s.add_development_dependency("factory_girl_rails")
  s.add_development_dependency("capybara")
end
