ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
  end

  create_table :products do |t|
  end

  %w[translations user_translations].each do |table|
    create_table table do |t|
      t.string :attribute
      t.text :text
      t.string :language
      t.integer :translatable_id
      t.string :translatable_type
    end
  end
end

#create model
class User < ActiveRecord::Base
  translated_attributes :name, :table_name=>:user_translations, :nil_to_blank=>true
end

class Shop < ActiveRecord::Base
  set_table_name :products
  translated_attributes :shop_name
end

class Product < ActiveRecord::Base
  translated_attributes :title, :description
end