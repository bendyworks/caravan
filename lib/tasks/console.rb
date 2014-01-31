desc "Start Caravan console"
task :console do
  sh "bundle exec pry -r ./config/console.rb"
end
