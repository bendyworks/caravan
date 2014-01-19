require 'rake'
require 'rspec/core/rake_task'

Dir['./lib/tasks/*.rb'].sort.each do |task|
  require task
end

desc 'A task for doing everything to set up this project'
task :bootstrap => ['db:create', 'db:migrate']

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
