# frozen_string_literal: true

module UploaderHelpers
  def upload_image
    Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/sample_image.png'))
  end

  def upload_pdf
    Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/sample_pdf.pdf'))
  end

  def uploaded_image
    file = File.open('spec/attachments/sample_image.png', binmode: true)
    # for performance we skip metadata extraction and assign test metadata
    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      'size'      => File.size(file.path),
      'mime_type' => 'image/jpeg',
      'filename'  => 'test.jpg',
    )

    uploaded_file
  end

  def uploaded_pdf
    file = File.open('spec/attachments/sample_pdf.pdf', binmode: true)

    # for performance we skip metadata extraction and assign test metadata
    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      'size'      => File.size(file.path),
      'mime_type' => 'file/pdf',
      'filename'  => 'test.pdf',
    )

    uploaded_file
  end

  private

  def image_data
    attacher = Shrine::Attacher.new
    attacher.set(uploaded_image)

    # if you're processing derivatives
    attacher.set_derivatives(
      large:  uploaded_image,
      medium: uploaded_image,
      small:  uploaded_image,
    )
    attacher.column_data # or attacher.data in case of postgres jsonb column
  end
end
