require 'rake/testtask'

# to run
# local test suite: rake local TESTOPTS='-v'
# remote test suite: rake remote TESTOPTS='-v'

task :test_local do
  Rake::TestTask.new('local') do |t|
    puts 'Sinatra application tests'
    t.libs.push 'specs'
    t.pattern = "spec/spec-local-*.rb"
  end
end

task :test_remote do
  Rake::TestTask.new('remote') do |t|
    puts 'Remote server tests'
    t.pattern = "spec/spec-remote-*.rb"
  end
end

task :remote do
  Rake::Task["test_local"].clear
  Rake::Task["test_remote"].invoke
end

task :local do
  Rake::Task["test_remote"].clear
  Rake::Task["test_local"].invoke
end
