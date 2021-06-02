class Taxi < ApplicationRecord
  belongs_to :new_car
  belongs_to :equipment
  mount_uploaders :images, TaxiUploader
end
