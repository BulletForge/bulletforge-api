# frozen_string_literal: true

module Types
  class DirectUploadType < Types::BaseObject
    field :signed_url, String, 'Signed upload URL', null: false
    field :headers, GraphQL::Types::JSON, 'HTTP request headers', null: false
    field :signed_blob_id, String, 'Created blob record signed ID', null: false
  end
end
