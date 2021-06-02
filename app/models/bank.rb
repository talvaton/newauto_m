class Bank < ApplicationRecord
  mount_uploader :image, BankUploader

  before_save :generate_url

  def generate_url
    unless self.url
      self.url = self.name.parameterize
    end
  end
end
