ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
  end

  create_table :products do |t|
  end

  create_table :translations do |t|
    t.string :attribute
    t.text :text
    t.string :language
    t.integer :translateable_id
    t.string :translateable_type
  end
end

#create model
class User < ActiveRecord::Base
  virtual_translations :name
end

class Product < ActiveRecord::Base
  virtual_translations :title, :description
end