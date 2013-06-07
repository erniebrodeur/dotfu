#!/usr/bin/ruby

# Must be an array
test_cmd = [
  "bundle exec dotfu install zsh",
  "bundle exec dotfu uninstall zsh"
]

guard :bundler do
  watch 'Gemfile'
  watch '*.gemspec'
end

# guard :rspec do
#   watch(%r{^spec/.+_spec\.rb$})
#   watch(%r{^lib/(.+)\.rb$}) { |m| "spec spec/lib/#{m[1]}_spec.rb" }
#   watch(%r{^bin/(.+)\.rb$})         { |m| "spec/bin/#{m[1]}_spec.rb" }
#   watch('spec/spec_helper.rb')      { "spec" }
#   watch('spec/shared_examples.rb')      { "spec" }
# end

# guard :yard do
#   watch(%r{^lib/(.+)\.rb$})
# end

# guard :shell do
#   watch /.*/ do |m|
#     puts "Time: #{Time.now}, file saved: #{m}"
#     test_cmd.each do |cmd|

#       puts "=" * 80
#       puts "cmd: #{cmd}"
#       puts `#{cmd}`
#     end
#   end
# end

guard 'minitest' do
  # with Minitest::Unit
  watch(%r|^test/(.*)\/?test_(.*)\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }

  # with Minitest::Spec
  # watch(%r|^spec/(.*)_spec\.rb|)
  # watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  # watch(%r|^spec/spec_helper\.rb|)    { "spec" }

  # Rails 3.2
  # watch(%r|^app/controllers/(.*)\.rb|) { |m| "test/controllers/#{m[1]}_test.rb" }
  # watch(%r|^app/helpers/(.*)\.rb|)     { |m| "test/helpers/#{m[1]}_test.rb" }
  # watch(%r|^app/models/(.*)\.rb|)      { |m| "test/unit/#{m[1]}_test.rb" }

  # Rails
  # watch(%r|^app/controllers/(.*)\.rb|) { |m| "test/functional/#{m[1]}_test.rb" }
  # watch(%r|^app/helpers/(.*)\.rb|)     { |m| "test/helpers/#{m[1]}_test.rb" }
  # watch(%r|^app/models/(.*)\.rb|)      { |m| "test/unit/#{m[1]}_test.rb" }
end
