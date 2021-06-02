class Review < ApplicationRecord
  mount_uploader :image, ReviewUploader
  belongs_to :new_car, optional: true
end
