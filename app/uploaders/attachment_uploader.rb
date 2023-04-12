# frozen_string_literal: true
# This is just a sample uploader, please remove it or rename it to something else
class AttachmentUploader < Shrine
  # Needed for including processing on images using mini_magick
  plugin :delete_raw # delete processed files after uploading
  plugin :validation_helpers
  plugin :remote_url, max_size: 8 * 1024 * 1024
  plugin :determine_mime_type

  Attacher.validate do
    validate_max_size 8 * 1024 * 1024, message: 'is too large (max is 8 MB)'
    validate_mime_type_inclusion %w(file/pdf)
  end
end
