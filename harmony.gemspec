# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "harmony/version"

Gem::Specification.new do |s|
  s.name        = "kuntoaji-harmony"
  s.version     = Harmony::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["mynyml", "Kunto Aji Kristianto", "baccigalupi"]
  s.email       = ["mynyml@gmail.com", "kunto.aji.kr@gmail.com", "baccigalupi@gmail.com"]
  s.homepage    = "http://github.com/kuntoaji/harmony"
  s.summary     = %q{Javascript + DOM in your ruby, the simple way}
  s.description = %q{Javascript + DOM in your ruby, the simple way. More memory sensitive based on baccigalupi's repos. Kuntoaji's version.}

  #s.rubyforge_project = ""

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'johnson', '2.0.0.pre3'
  s.add_dependency 'envjs', '0.3.7'
  s.add_development_dependency 'minitest'
end
