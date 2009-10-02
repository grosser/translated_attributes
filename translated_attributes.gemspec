# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{translated_attributes}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Grosser"]
  s.date = %q{2009-07-19}
  s.email = %q{grosser.michael@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "MIGRATION",
     "README.markdown",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "VERSION",
     "init.rb",
     "lib/translated_attributes.rb",
     "lib/translated_attributes.rb",
     "spec/integration_spec.rb",
     "spec/integration_spec.rb",
     "spec/models.rb",
     "spec/models.rb",
     "spec/spec_helper.rb",
     "spec/spec_helper.rb",
     "spec/translated_attributes_spec.rb",
     "spec/translated_attributes_spec.rb"
  ]
  s.homepage = %q{http://github.com/grosser/translated_attributes}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{ActiveRecord/Rails simple translatable attributes}
  s.test_files = [
    "spec/integration_spec.rb",
     "spec/spec_helper.rb",
     "spec/translated_attributes_spec.rb",
     "spec/models.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
  end
end