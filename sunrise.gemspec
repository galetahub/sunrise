version = File.open(File.dirname(__FILE__) + '/VERSION', 'r').read.strip

Gem::Specification.new do |gem|
  gem.name = "sunrise"
  gem.version = version
  gem.summary = %Q{Rails CMS}
  gem.description = %Q{Sunrise is a Aimbulance CMS.}
  gem.email = "galeta.igor@gmail.com"
  gem.homepage = "https://github.com/galetahub/sunrise"
  gem.authors = ["Igor Galeta", "Pavlo Galeta"]
  
  gem.files = Dir.glob("{lib}/**/*") + %w(README.rdoc LICENSE)
  
  %w(sunrise-core sunrise-scaffold).each do |subgem|
    gem.add_dependency subgem, version
  end
end
