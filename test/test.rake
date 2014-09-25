desc "Run application test suite"
task 'test' do
  ruby("test/run-test.rb")
end

task :default => :test
