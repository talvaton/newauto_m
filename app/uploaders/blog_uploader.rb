class BlogUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # if Rails.env.salon_dev? || Rails.env.rcar_dev?
  #   storage :fog
  # else
  #   storage :file
  # end


  def store_dir
      "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :thumb do
    process :resize_to_fill => [410, 245]
    process optimize: [{
                           jpegoptim: true
                       }]
  end
  version :large do
    process :resize_to_fill => [500, 300]
    process optimize: [{
                           jpegoptim: true
                       }]
  end

  # Parametirize filename
  def filename
    "#{file.basename.parameterize}.#{file.extension}" if original_filename.present?
  end
end