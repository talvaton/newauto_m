class CompareUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptim

  storage :file

  def store_dir
    "uploads/equipment_description/#{model.id}/compare"
  end

  version :original_webp do
    convert :webp
    def full_filename(name)
      "#{original_filename}.webp"
      # "#{name}.webp"
    end
  end

  version :large do
    process :resize_and_pad => [260, 160]
    process optimize: [{
                           jpegoptim: true,
                           pngquant: false
                       }]
  end

  version :large_webp,from_version: :large do
    convert :webp
    def full_filename(name)
      "large_#{original_filename}.webp"
    end
  end

  version :thumb do
    process :resize_and_pad => [80, 50]
    process optimize: [{
                           jpegoptim: true,
                           pngquant: false
                       }]
  end

  version :thumb_webp,from_version: :thumb do
    convert :webp
    def full_filename(name)
      "thumb_#{original_filename}.webp"
    end
  end

  def filename
    "#{file.basename.parameterize}.#{file.extension}" if original_filename.present?
  end

end