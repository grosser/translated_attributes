task :default => :spec
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new {|t| t.spec_opts = ['--color']}

begin
  project_name = 'translated_attributes'
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = project_name
    gem.summary = "ActiveRecord/Rails simple translatable attributes"
    gem.email = "grosser.michael@gmail.com"
    gem.homepage = "http://github.com/grosser/#{project_name}"
    gem.authors = ["Michael Grosser"]
    gem.add_dependency ['activerecord']
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end