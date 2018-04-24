class Product < ActiveRecord::Base
  belongs_to :seller, required: true, class_name: 'User'
  belongs_to :buyer, class_name: 'User'
end
