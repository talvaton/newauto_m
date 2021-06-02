class BankUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # file = "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  #
  # unless File.exist?(file)
  # storage :file
  # storage :fog
  # storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :optimized do

    process :resize_to_fill => [150, 55]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end

  def filename
    "#{file.basename.parameterize}.#{file.extension}" if original_filename.present?
  end

end