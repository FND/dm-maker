# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)
require "dm-maker/version"

DM_VERSION = "1.2.0"

Gem::Specification.new do |s|
  s.name        = "dm-maker"
  s.version     = DataMapper::Maker::VERSION
  s.authors     = ["FND"]
  s.summary     = "DataMapper extension to generate instances from YAML"
  s.description = "initializes resources from YAML data"

  s.rubyforge_project = "dm-maker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/test_*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "dm-core", DM_VERSION
  s.add_dependency "active_support"
  s.add_dependency "i18n"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "rake"
  s.add_development_dependency "dm-migrations", DM_VERSION
  s.add_development_dependency "dm-transactions", DM_VERSION
  s.add_development_dependency "dm-sqlite-adapter", DM_VERSION
end
