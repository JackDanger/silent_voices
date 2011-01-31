Rake.application.options.trace = true

GUTENBERG_SOURCE = File.expand_path File.join(File.dirname(__FILE__), 'vendor', '8924.txt.utf8')

require File.expand_path File.join(File.dirname(__FILE__), 'lib', 'silent_voices')

desc "Build the project"
task :build do
  SilentVoices::Compiler.new(File.read GUTENBERG_SOURCE).process
  exec 'open index.html'
end

task :deploy do
  system %Q{git commit voices index.html -m "building"}
  system %Q{git push github master}
  system %Q{ssh 9suits.com "cd /www/silentvoicesbible.com; git pull"}

end
