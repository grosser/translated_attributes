desc "Run all specs in spec directory"
task :default do
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end

begin
  project = 'translated_attributes'
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = project
    gem.summary = "ActiveRecord/Rails simple translatable attributes"
    gem.email = "grosser.michael@gmail.com"
    gem.homepage = "http://github.com/grosser/#{project}"
    gem.authors = ["Michael Grosser"]
    gem.files += (FileList["{lib,spec}/**/*"] + FileList["VERSION"] + FileList["README.markdown"]).to_a.sort
    gem.add_dependency ['activerecord']
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end