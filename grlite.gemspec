# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require "grlite/version"

Gem::Specification.new do |s|
    s.name          = 'grlite'
    s.version       = GRLite::VERSION
    s.authors       = ['Alex Blount']
    s.email         = ['axblount@email.arizona.edu']
    s.homepage      = ''
    s.summary       = %q{TODO}
    s.description   = %q{TODO}
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
    s.require_paths = ['lib']

    s.add_runtime_dependency 'sqlite3'
end
