
GUTENBERG_SOURCE = File.expand_path File.join(File.dirname(__FILE__), 'vendor', '8924.txt.utf8')

require File.expand_path File.join(File.dirname(__FILE__), 'lib', 'silent_voices')

desc "Build the project"
task :build do
  SilentVoices::Compiler.new(File.read GUTENBERG_SOURCE).process
end