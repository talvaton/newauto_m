class Story < ApplicationRecord
  mount_uploader :newsImage, StoryUploader
  before_save :generate_url

  def generate_url
    unless self.url
      self.url = self.title.parameterize
    end
  end
end
