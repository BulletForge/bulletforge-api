# frozen_string_literal: true

module Mutations
  class CreateDirectUpload < Mutations::BaseMutation
    FILE_SIZE_LIMIT_IN_MB = 300
    FILE_SIZE_LIMIT = FILE_SIZE_LIMIT_IN_MB.megabytes

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
      return error_response unless user_errors.empty?

      blob = ActiveStorage::Blob.create_before_direct_upload!(
        filename: filename,
        byte_size: byte_size,
        checksum: checksum,
        content_type: content_type
      )

      success_response(blob)
    end

    private

    def success_response(blob)
      {
        direct_upload: {
          url: blob.service_url_for_direct_upload,
          headers: blob.service_headers_for_direct_upload.to_json,
          blob_id: blob.id,
          signed_blob_id: blob.signed_id
        },
        errors: []
      }
    end

    def error_response
      { direct_upload: nil }.merge(super)
    end
  end
end
