# frozen_string_literal: true

module Mutations
  class CreateDirectUpload < Mutations::BaseMutation
    null true

    argument :filename, String, 'Original file name', required: true
    argument :checksum, String, 'MD5 file checksum as base64', required: true
    argument :content_type, String, 'File content type', required: true
    argument :byte_size, Integer, 'File size (bytes)', required: true

    field :direct_upload, Types::DirectUploadType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def resolve(filename:, byte_size:, checksum:, content_type:)
      blob = create_blob(filename, byte_size, checksum, content_type)
      success_response(blob)
    end

    private

    def create_blob(filename, byte_size, checksum, content_type)
      ActiveStorage::Blob.create_before_direct_upload!(
        filename: filename,
        byte_size: byte_size,
        checksum: checksum,
        content_type: content_type
      )
    end

    def success_response(blob)
      {
        direct_upload: blob,
        errors: []
      }
    end

    def error_response
      {
        direct_upload: nil,
        errors: user_errors
      }
    end
  end
end
