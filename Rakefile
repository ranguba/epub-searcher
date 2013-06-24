task :default => :test

task :test do
  sh('ruby', '-w', '-I', 'lib', 'test/test-epub-document.rb')
  sh('ruby', '-w', '-I', 'lib', 'test/test-database.rb')
end
