require 'rails/generators/migration'

class TranslatedAttributesGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)
  
  def self.next_migration_number(dirname)
    Time.now.strftime("%Y%m%d%H%M%S")
  end
  
  def create_migration
    migration_template "#{self.class.source_root}/migration.rb", File.join('db/migrate', "add_translations.rb")
  end
end
