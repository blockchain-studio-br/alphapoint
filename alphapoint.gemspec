
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "alphapoint/version"

Gem::Specification.new do |spec|
  spec.name          = "alphapoint"
  spec.version       = Alphapoint::VERSION
  spec.authors       = ["Fabiano Martins", "Lucas Pérez","Miguel Corti"]
  spec.email         = ["fabiano.paula.martins@gmail.com", "lucas@blockchainstudio.com.br", "miguelszcorti@gmail.com"]

  spec.summary       = "Alphapoint websocket DSL"
  spec.description   = "Alphapoint websocket DSL is to easy request and listen event"
  spec.homepage      = "https://github.com/blockchain-studio-br/alphapoint"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

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

  spec.add_dependency "activesupport", ">= 5.1.6", "< 7.1.0"

  spec.add_runtime_dependency "eventmachine",   "~> 1.2.7",  ">= 1.2.7"
  spec.add_runtime_dependency "faye-websocket", "~> 0.10.7", ">= 0.10.7"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.12.2", ">= 0.12.2"
  spec.add_development_dependency "byebug", "~> 11.0.1"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3", ">= 4.7.3"

end
