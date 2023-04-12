# frozen_string_literal: true

# This is just a sample uploader, please remove it or rename it to something else
require 'image_processing/mini_magick'
class ImageUploader < Shrine
  MAX_SIZE = 8 * 1024 * 1024
  plugin :delete_raw # delete processed files after uploading
  plugin :validation_helpers
  plugin :remote_url, max_size: MAX_SIZE
  plugin :determine_mime_type

  Attacher.derivatives do |original|
    pipeline = ImageProcessing::MiniMagick.source(original)
    # add as many sizes as you want
    large = pipeline.resize_to_fit!(1080, 1080)
    medium = pipeline.resize_to_fit!(540, 540)
    thumbnail = pipeline.resize_to_fit!(220, 220)
    # add the sizes in a hash
    { large: large, medium: medium, thumbnail: thumbnail }
  end

  Attacher.validate do
    validate_max_size MAX_SIZE, message: 'is too large (max is 8 MB)'
    validate_mime_type_inclusion %w(image/jpeg image/png)
  end
end
