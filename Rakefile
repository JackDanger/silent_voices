
GUTENBERG_SOURCE = File.expand_path File.join(File.dirname(__FILE__), 'vendor', '8924.txt.utf8')
COMPILED_SOURCE  = File.expand_path File.join(File.dirname(__FILE__), 'vendor', '8924.txt.compiled')

task :compile do
  File.open COMPILED_SOURCE, 'w' do |f|
    f.write SilentVoices::Compiler.new(File.read GUTENBERG_SOURCE).process
  end
end