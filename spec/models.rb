ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
  end

  create_table :products do |t|
  end
end

#create model
class User < ActiveRecord::Base
  virtual_translations :name
end

class Product < ActiveRecord::Base
  virtual_translations :title, :description
end