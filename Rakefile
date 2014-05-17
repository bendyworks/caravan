require 'rake'

Dir['./lib/tasks/*.rb'].sort.each do |task|
  require task rescue LoadError
end

task :default => [:cane, :spec]
