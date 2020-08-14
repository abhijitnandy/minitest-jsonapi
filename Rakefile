require "rake/testtask"

Rake::TestTask.new(:test) do |t|
	t.options = '-J --addr=http://localhost:4567/ --keyname=ABCD --keyvalue=EFGH'
	t.test_files = FileList["test/**/test_*.rb"]
end
task :default => :test


Rake::TestTask.new("test:pretty") do |t|
	t.options = '-J --pretty'
	t.test_files = FileList["test/**/test_*.rb"]
end