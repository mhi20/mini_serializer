
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mini_serializer/version"

Gem::Specification.new do |spec|
  spec.name          = "mini_serializer"
  spec.version       = MiniSerializer::VERSION
  spec.authors       = ["mahdi alizadeh"]
  spec.email         = ["mahdializadeh20@gmail.com"]

  spec.summary       = %q{Serializes Activemodel object to JSON API format}
  spec.description   = %q{Serializes Activemodel object to JSON API format}
  spec.homepage      = "https://github.com/mhi20/mini_serializer"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rails", "~> 5.0"
end
