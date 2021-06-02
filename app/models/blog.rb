class Blog < ApplicationRecord
  mount_uploaders :images, BlogUploader

  belongs_to :brand, optional: true
  belongs_to :new_car, optional: true

end
