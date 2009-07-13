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
      t.integer :translateable_id
      t.string :translateable_type
    end
  end
end

#create model
class User < ActiveRecord::Base
  virtual_translations :name, :table_name=>:user_translations
end

class Product < ActiveRecord::Base
  virtual_translations :title, :description
end