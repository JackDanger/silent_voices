Rake.application.options.trace = true

GUTENBERG_SOURCE = File.expand_path File.join(File.dirname(__FILE__), 'vendor', '8924.txt.utf8')

require File.expand_path File.join(File.dirname(__FILE__), 'lib', 'silent_voices')

namespace :build do
  desc "Build the whole project"
  task :all do
    SilentVoices::Compiler.new(File.read(GUTENBERG_SOURCE), 'books').process :web, :kindle
  end

  desc "Build an html file for Kindle publishing"
  task :kindle do
    SilentVoices::Compiler.new(File.read(GUTENBERG_SOURCE), 'books').process :kindle
  end

  desc "Build the html files for the web"
  task :web do
    SilentVoices::Compiler.new(File.read(GUTENBERG_SOURCE), 'books').process :web
  end

  desc "Build the front pages"
  task :front do
    SilentVoices::Compiler.new(File.read(GUTENBERG_SOURCE), 'front').process
  end

  desc "Skip the compilation step"
  task :fast do
    SilentVoices::Compiler.new(File.read(GUTENBERG_SOURCE), 'fast').process
  end

  desc "Build the blog"
  task :blog do
    system 'cd _blog_src; jekyll; cd -'
  end
end

task :build => ['build:all', 'build:blog']
task :blog => ['build:blog', 'see_blog']

task :see do
  system 'open index.html'
end
task :see_blog do
  system 'open blog/index.html'
end
task :live do
  system 'open http://silentvoicesbible.com/'
end

task :irb do
  exec "irb -rubygems -I'lib' -r silent_voices"
end

task :deploy do
  system %Q{git commit voices index.html blog -m "building"}
  system %Q{git push github master}
  system %Q{ssh 9suits.com "cd /www/silentvoicesbible.com; git pull"}
end
