lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'murmur/version'

Gem::Specification.new do |gem|
    gem.name            = "murmur"
    gem.version         = Murmur::VERSION
    gem.authors         = ["Ranndom"]
    gem.email           = ["Ranndom@rnndm.xyz"]
    gem.description     = %q{Ruby client for controlling and querying Murmur}
    gem.summary         = %q{A ruby client for controlling and querying the Mumble server (Murmur)}
    gem.homepage        = "https://github.com/Ranndom/Murmur"

    gem.files           = `git ls-files`.split($/)
    gem.test_files      = gem.files.grep(%r{^(test|spec)/})
    gem.require_paths   = ["lib"]

    gem.add_runtime_dependency 'zeroc-ice'

    gem.add_development_dependency 'rake'
end
