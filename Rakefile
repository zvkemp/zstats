require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << 'lib/zstats'
  t.test_files = FileList['spec/lib/zstats/*_spec.rb']
  t.verbose    = true
end
task default: :test
