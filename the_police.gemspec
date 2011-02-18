# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "the_police/version"

Gem::Specification.new do |s|
  s.name        = "the_police"
  s.version     = ThePolice::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mathias Biilmann"]
  s.email       = ["mathiasch@webpop.com"]
  s.homepage    = ""
  s.summary     = %q{Log errors to a capped mongodb collection}
  s.description = %q{Simple middleware for logging errors to a capped mongodb collection.}

  s.rubyforge_project = "the_police"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
