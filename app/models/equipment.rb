class Equipment < ApplicationRecord
  belongs_to :specification
  belongs_to :equipment_description
  has_many :new_cars, :through => :specification
  has_many :taxis
end
