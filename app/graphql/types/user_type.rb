# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: true
    field :login, String, null: true
    field :projects, Types::ProjectType.connection_type, null: false

    def id
      object.to_param
    end
  end
end
