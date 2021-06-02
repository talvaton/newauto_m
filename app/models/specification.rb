class Specification < ApplicationRecord
  belongs_to :new_car
  has_many :equipment
end
