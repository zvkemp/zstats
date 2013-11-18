# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest', :all_on_start => true do
  watch(%r|^spec/(.*)([^/]+)_spec\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r|^spec/spec_helper\.rb|)    { "spec" }
  watch(%r|^lib/zstats\.rb|) { "spec" }
end