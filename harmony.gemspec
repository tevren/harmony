require 'lib/harmony'

Gem::Specification.new do |s|
  s.name                = "harmony"
  s.summary             = "Javascript + DOM in your ruby, the simple way"
  s.description         = "Javascript + DOM in your ruby, the simple way."
  s.author              = "mynyml"
  s.email               = "mynyml@gmail.com"
  s.homepage            = "http://github.com/mynyml/harmony"
  s.rubyforge_project   = "harmony"
  s.require_path        = "lib"
  s.version             =  Harmony::VERSION
  s.files               =  File.read("Manifest").strip.split("\n")

  s.add_dependency 'johnson', '2.0.0.pre3'
  s.add_dependency 'envjs', '0.3.7'
  s.add_development_dependency 'minitest'
end
