class UsedCar < ApplicationRecord
  belongs_to :brand

  mount_uploaders :images, UsedcarImagesUploader

  before_save :generate_url

  def generate_url
    self.url = self.name.parameterize
  end

  def self.special_cars(limit = 0)
    if limit == 0
      where(hide:0, used: 0)
    else
      where(hide:0, used: 0).limit(limit)
    end

  end

  def self.used_cars(limit = 0)
    if limit == 0
      where(hide:0, used: 1)
    else
      where(hide:0, used: 1).limit(limit)
    end
  end
end
