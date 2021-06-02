class BrandCertUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  version :optimized do
    process :resize_to_fill => [600, 400]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end

  # Parametirize filename
  def filename
    "#{file.basename.parameterize}.#{file.extension}" if original_filename.present?
  end
end