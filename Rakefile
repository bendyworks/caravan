require 'rake'

Dir['./lib/tasks/*.rb'].sort.each do |task|
  require task
end

desc 'A task for doing everything to set up this project'
task :bootstrap => ['db:create', 'db:migrate']
