class ReviewUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # storage :file

  def store_dir
    # if Rails.env.salon_dev? || Rails.env.rcar_dev?
    #   "tmp/seed/#{model.class.to_s.underscore}/#{mounted_as}"
    # else
      "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    # end
  end

  version :optimized do
    process :resize_to_fill => [410, 245]
    process optimize: [{
                           jpegoptim: true,
                           pngquant: false
                       }]
  end

  # Parametirize filename
  def filename
    "#{file.basename.parameterize}.#{file.extension}" if original_filename.present?
  end
end