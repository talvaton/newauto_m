class NewcarColorUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # if Rails.env.salon_dev? || Rails.env.rcar_dev?
  #   storage :fog
  # else
  # storage :file
  # end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :feed do
    process :resize_to_fit => [640, 480]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end

  version :topnav do
    process :resize_to_fill => [158, 82]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end

  version :card do
    process :resize_to_fill => [260, 134]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end

  version :largecard do
    process :resize_to_fill => [484, 250]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end


  # Parametirize filename
  def filename
    "#{file.basename.parameterize.gsub('-','_').gsub('__','_')}.#{file.extension}".gsub('_.','.') if original_filename.present?
  end
end
