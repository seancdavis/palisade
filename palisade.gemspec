# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'palisade/version'

Gem::Specification.new do |spec|
  spec.name          = "palisade"
  spec.version       = Palisade::VERSION
  spec.authors       = ["Sean C Davis"]
  spec.email         = ["scdavis41@gmail.com"]
  spec.summary       = %q{Automate regular backups of remote data.}
  spec.description   = %q{Automate regular backups of remote data.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message = "
  ------------------------------

  Thanks for installing Palisade! 

  Before you start building your fort, you need to install a
  config file. Don't forget to run this command:

      palisade install

  And then edit the config file!

  ------------------------------
  "

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
