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
    gem.files += (FileList["{lib,spec}/**/*"] + FileList["VERSION"] + FileList["README.markdown"]).to_a.sort
    gem.add_dependency ['activerecord']
    gem.rubyforge_project = 'translated-attr'
  end

  # fake task so that rubyforge:release works
  task :rdoc do
    `mkdir rdoc`
    `echo documentation is at http://github.com/grosser/#{project_name} > rdoc/README.rdoc`
  end

  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end