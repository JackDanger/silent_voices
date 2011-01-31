Rake.application.options.trace = true

GUTENBERG_SOURCE = File.expand_path File.join(File.dirname(__FILE__), 'vendor', '8924.txt.utf8')

require File.expand_path File.join(File.dirname(__FILE__), 'lib', 'silent_voices')

namespace :build do
  desc "Build the whole project project"
  task :all do
    SilentVoices::Compiler.new(File.read(GUTENBERG_SOURCE), 'books').process
  end

  desc "Build the front pages"
  task :front do
    SilentVoices::Compiler.new(File.read(GUTENBERG_SOURCE), false).process
  end
end

task :build => 'build:all'

task :see do
  exec 'open index.html'
end
task :live do
  exec 'open http://silentvoicesbible.com/'
end

task :deploy do
  system %Q{git commit voices index.html -m "building"}
  system %Q{git push github master}
  system %Q{ssh 9suits.com "cd /www/silentvoicesbible.com; git pull"}

end
