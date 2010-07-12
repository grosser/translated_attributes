class AddTranslations < ActiveRecord::Migration
  def self.up
    #you can remove the limit/null constrains
    #this is simply my recommended way of setting things up (save + limits needed storage space)
    create_table :translations do |t|
      t.integer :translatable_id, :null=>false
      t.string :translatable_type, :limit=>40, :null=>false
      t.string :language, :limit=>2, :null=>false
      t.string :attr, :limit=>40, :null=>false
      t.text :text, :null=>false
    end
    add_index :translations, [:translatable_id, :translatable_type]
  end

  def self.down
    drop_table :translations
  end
end
