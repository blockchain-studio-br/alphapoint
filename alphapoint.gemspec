
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "alphapoint/version"

Gem::Specification.new do |spec|
  spec.name          = "alphapoint"
  spec.version       = Alphapoint::VERSION
  spec.authors       = ["Miguel Corti", "Fabiano Martins"]
  spec.email         = ["miguelszcorti@gmail.com", "fabiano.paula.martins@gmail.com"]

  spec.summary       = "Alphapoint websocket DSL"
  spec.description   = "Alphapoint websocket DSL is to easy request and listen event"
  spec.homepage      = "https://github.com/blockchain-studio-br/alphapoint"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/blockchain-studio-br/alphapoint"
    spec.metadata["changelog_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir['Gemfile', 'LICENSE.md', 'README.md', 'lib/**/*']
  spec.require_paths = %w(lib)

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "eventmachine"
  spec.add_development_dependency "guard-rspec"
  # spec.add_development_dependency "faye"
  spec.add_development_dependency "faye-websocket"
end
