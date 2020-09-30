# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunrise/version'

Gem::Specification.new do |s|
  s.name = 'sunrise-cms'
  s.version = Sunrise::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary = 'Rails CMS'
  s.description = 'Sunrise is a Open Source CMS'
  s.authors = ['Igor Galeta', 'Pavlo Galeta']
  s.email = 'galeta.igor@gmail.com'
  s.homepage = 'https://github.com/galetahub/sunrise'
  s.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir = 'bin'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency('kaminari')
  s.add_dependency('rails', '>= 4.0.0')
  s.add_dependency('simple_form')

  s.add_dependency('babosa')
  s.add_dependency('cancan')
  # s.add_dependency('cancan_namespace')
  s.add_dependency('carrierwave')
  s.add_dependency('galetahub-enum_field')
  s.add_dependency('jquery-ui-rails', '>= 5.0.0')
  s.add_dependency('meta_manager', '>= 0.2.0')
  s.add_dependency('mime-types')
  s.add_dependency('mini_magick')
  s.add_dependency('page_parts', '>= 0.1.3')
  s.add_dependency('public_activity', '>= 1.0.0')
  s.add_dependency('rails-settings-cached', '>= 0.4.0')
  s.add_dependency('rails-uploader')
  s.add_dependency('select2-rails')

  s.add_development_dependency('capybara')
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency('factory_girl_rails')
  s.add_development_dependency('rspec-rails')
end
