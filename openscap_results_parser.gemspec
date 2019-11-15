
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "openscap_results_parser/version"

Gem::Specification.new do |spec|
  spec.name          = 'openscap_results_parser'
  spec.version       = OpenscapParser::VERSION
  spec.authors       = ['Daniel Lobato Garcia', 'Andrew Kofink']
  spec.email         = ['me@daniellobato.me', 'ajkofink@gmail.com']

  spec.summary       = %q{Parse OpenSCAP content}
  spec.description   = %q{This gem is a Ruby interface into SCAP content. It can parse SCAP datastream files (i.e. ssg-rhel7-ds.xml), scan result files output by oscap eval, and tailoring files.}
  spec.homepage      = 'https://github.com/dLobatog/openscap_results_parser'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
   # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    # spec.metadata["homepage_uri"] = spec.homepage
   # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
   # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against " \
  #    "public gem pushes."
  #end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.0"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
