# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)
require "dm-yamler/version"

DM_VERSION = "1.2.0"

Gem::Specification.new do |s|
  s.name        = "dm-yamler"
  s.version     = DMYamler::VERSION
  s.authors     = ["FND"]
  s.summary     = "DataMapper extension to generate instances from YAML"
  s.description = s.summary # TODO

  s.rubyforge_project = "dm-yamler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/test_*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "dm-core", DM_VERSION
  s.add_dependency "active_support"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "rake"
  s.add_development_dependency "dm-migrations", DM_VERSION
  s.add_development_dependency "dm-transactions", DM_VERSION
  s.add_development_dependency "dm-sqlite-adapter", DM_VERSION
end
