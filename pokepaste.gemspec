Gem::Specification.new do |gem|
  gem.name = "pokepaste"
  gem.version = File.read "VERSION"

  gem.author = "Vinny Diehl"
  gem.email = "vinny.diehl@gmail.com"
  gem.homepage = "https://github.com/vinnydiehl/pokepaste-ruby"

  gem.license = "MIT"

  gem.summary = "PokéPaste parser for Ruby"
  gem.description = "Parses PokéPastes into an object that you can easily read/manipulate/save."

  gem.require_paths = %w[lib]
  gem.test_files = Dir["spec/**/*"]
  gem.files = Dir["lib/**/*"] + gem.test_files + %w[
    VERSION Rakefile README.md LICENSE.md pokepaste.gemspec
  ]

  gem.required_ruby_version = ">= 2.0"
  gem.add_development_dependency "rake", "~> 13.0"
  gem.add_development_dependency "rspec", "~> 3.12"
  gem.add_development_dependency "fuubar", "~> 2.5"
  gem.add_development_dependency "yard", "~> 0.9"
end
