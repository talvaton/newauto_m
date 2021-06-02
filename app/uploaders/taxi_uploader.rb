class TaxiUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  # storage :fog
  storage :file

  def store_dir
    "uploads/taxi/#{model.id}/images"
  end

  process optimize: [{
                         pngquant: {:quality => 65..80},
                         jpegoptim: true
                     }]

  version :card do
    process :resize_to_fit => [280, 192]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end

  # Parametirize filename
  def filename
    "#{file.basename.parameterize.gsub('-','_').gsub('__','_')}.#{file.extension}".gsub('_.','.') if original_filename.present?
  end

end
