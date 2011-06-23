ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
    t.integer :version, :default => 0, :null => false
  end

  create_table :products do |t|
  end

  %w[translations user_translations].each do |table|
    create_table table do |t|
      t.integer :translatable_id, :null=>false
      t.string :translatable_type, :limit=>40, :null=>false
      t.string :language, :limit=>2, :null=>false
      t.string :translated_attribute, :limit=>40, :null=>false
      t.text :text, :null=>false
    end
  end
end

#create model
class User < ActiveRecord::Base
  translated_attributes :name, :table_name=>:user_translations, :nil_to_blank=>true
  after_save :inc_version

  def inc_version
    self.version += 1
  end
end

class Shop < ActiveRecord::Base
  set_table_name :products
  translated_attributes :shop_name
end

class Product < ActiveRecord::Base
  translated_attributes :title, :description
end
