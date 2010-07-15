require 'rails/generators/migration'

class TranslatedAttributesGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.next_migration_number(dirname)
    Time.now.strftime("%Y%m%d%H%M%S")
  end
  
  def create_migration
    template = File.expand_path('../templates/migration.rb', __FILE__)
    migration_template template, 'db/migrate/add_translations.rb'
  end
end
