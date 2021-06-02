class UsedcarImagesUploader < CarrierWave::Uploader::Base
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

  process optimize: [{
                         pngquant: {:quality => 65..80},
                         jpegoptim: true
                     }]

  version :card do
    process :resize_to_fill => [280, 192]
    process optimize: [{
                           pngquant: {:quality => 65..80}
                       }]
  end

  # Parametirize filename
  def filename
    "#{file.basename.parameterize.gsub('-','_').gsub('__','_')}.#{file.extension}".gsub('_.','.') if original_filename.present?
  end

end
