class EquipmentDescription < ApplicationRecord
  belongs_to :new_car
  has_many :equipments
  has_many :specifications, :through => :equipments
  mount_uploaders :compare, CompareUploader
end
