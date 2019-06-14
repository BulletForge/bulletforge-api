# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    implements GraphQL::Relay::Node.interface

    global_id_field :id

    field :permalink, String, null: true
    field :title, String, null: true
    field :description, String, null: true
    field :version_number, String, null: true
  end
end
