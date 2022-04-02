namespace :css do
  desc 'Remove CSS builds'
  task :clobber do
    rm_rf Dir['app/assets/builds/[^.]*.css'], verbose: false
  end
end

namespace :javascript do
  desc 'Remove JavaScript builds'
  task :clobber do
    rm_rf Dir['app/assets/builds/[^.]*.js'], verbose: false
  end
end

if Rake::Task.task_defined?('assets:clobber')
  Rake::Task['assets:clobber'].enhance(['javascript:clobber', 'css:clobber'])
end

