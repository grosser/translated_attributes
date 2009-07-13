class Translation < ActiveRecord::Base
  belongs_to :translateable, :polymorphic=>true
end