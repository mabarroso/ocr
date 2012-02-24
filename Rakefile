require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

desc "Run all tests"
task :test do
  exec "rspec --color"
end

desc "Generate docs"
task :rdoc do
  exec "rdoc --all"
end
