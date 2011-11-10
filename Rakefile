# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)

require "rake/testtask"

Rake::TestTask.new do |task|
  task.libs << "test"
end

desc "Run tests"
task :default => :test
