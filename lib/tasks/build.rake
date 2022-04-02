namespace :css do
  desc 'Build your CSS bundle'
  task :build do
    system 'bin/sass', exception: true
  end
end

namespace :javascript do
  desc 'Build your JavaScript bundle'
  task :build do
    system 'yarn install && yarn build', exception: true
  end
end

if Rake::Task.task_defined?('assets:precompile')
  Rake::Task['assets:precompile'].enhance(['css:build', 'javascript:build'])
end

if Rake::Task.task_defined?('test:prepare')
  Rake::Task['test:prepare'].enhance(['css:build', 'javascript:build'])
elsif Rake::Task.task_defined?('db:test:prepare')
  Rake::Task['db:test:prepare'].enhance(['css:build', 'javascript:build'])
end
