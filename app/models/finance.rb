class Finance < ApplicationRecord
  belongs_to :brand
  before_save :generate_url

  def generate_url
    unless self.url
      self.url = self.name.parameterize
    end
  end
end
