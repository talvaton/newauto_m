class StoryUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # storage :file

  def store_dir
      "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as.to_s.underscore}"
  end

  version :optimized do
    process :resize_to_fill => [410, 245]
    process optimize: [{
                           jpegoptim: true,
                           pngquant: false
                       }]
  end

  version :mainimg do
    process :resize_to_fill => [1290, 570]
    process optimize: [{
                           jpegoptim: true,
                           pngquant: false
                       }]
  end

  # Parametirize filename
  def filename
    "#{file.basename.parameterize(separator: "_")}.#{file.extension}" if original_filename.present?
  end
end