require 'cane/rake_task'
require 'rake'
require 'rspec/core/rake_task'
require 'cane/rake_task'

Dir['./lib/tasks/*.rb'].sort.each do |task|
  require task
end

desc 'Run cane to check code quality'
Cane::RakeTask.new(:cane) do |cane|
  cane.abc_max = 15
end

RSpec::Core::RakeTask.new(:spec)
Cane::RakeTask.new(:cane) do |cane|
  cane.abc_max = 15
  #cane.add_threshold 'coverage/covered_percent', :>=, 99
end

task :default => [:cane, :spec]
