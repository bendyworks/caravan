require 'cane/rake_task'
require 'rake'
require 'rspec/core/rake_task'

Dir['./lib/tasks/*.rb'].sort.each do |task|
  require task
end

desc 'A task for doing everything to set up this project'
task :bootstrap => ['db:create', 'db:migrate']

desc 'Run cane to check code quality'
Cane::RakeTask.new(:cane) do |cane|
  cane.abc_max = 15
end

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :cane]
