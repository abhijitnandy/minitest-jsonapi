lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "minitest/jsonapi/version"

Gem::Specification.new do |spec|
  spec.name          = "minitest-jsonapi"
  spec.version       = Minitest::Jsonapi::VERSION
  spec.authors       = ["abhijit"]
  spec.email         = ["mail@abhij.it"]

  spec.summary       = 'Send JSON output to API for Minitest runs'
  spec.description   = 'For Minitest runs, show prettified JSON output on console or send to an API'
  spec.homepage      = "https://fossil.abhij.it/repos/minitest-jsonapi"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir['README.md', 'LICENSE', 'lib/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency 'minitest', "~> 5.14"
  spec.add_runtime_dependency 'json', "~> 2.5.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
