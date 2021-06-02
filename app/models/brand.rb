class Brand < ApplicationRecord
  mount_uploader :logo, BrandLogoUploader
  mount_uploader :logoblack, BrandLogoUploader
  mount_uploader :cert, BrandCertUploader
  mount_uploader :main_img,BrandMainUploader

  has_many :new_cars
  has_many :used_cars
  has_many :blogs
  has_many :reviews, :through => :new_cars

  before_save :generate_url

  def generate_url
    unless self.url
      self.url = self.title.parameterize
    end
  end

  def get_car_by_type

  end

  def to_param
    url
  end
end
