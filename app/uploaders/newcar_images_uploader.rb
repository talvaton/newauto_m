class NewcarImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # storage :file

  # process optimize: [{
  #                        pngquant: {:quality => 65..80},
  #                        jpegoptim: true
  #                    }]
  def store_dir
    # if Rails.env.salon_dev? || Rails.env.rcar_dev?
    #   "tmp/seed/#{model.class.to_s.underscore}/#{mounted_as}"
    # else
      "uploads/new_car/#{model.id}/images"
    # end
  end

  version :large do
    process :resize_to_fill => [1168, 584]
    process optimize: [{
                           jpegoptim: true,
                           pngquant: false
                       }]
  end

  version :thumb do
    process :resize_to_fill => [300, 150]
    process optimize: [{
                           jpegoptim: true,
                           pngquant: false
                       }]
  end

  version :available_thumb do
    process :resize_to_fill => [150, 90]
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
