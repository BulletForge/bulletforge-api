# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements GraphQL::Relay::Node.interface

    global_id_field :id

    field :permalink, String, null: true
    field :email, String, null: true
    field :login, String, null: true
    field :admin, Boolean, null: true

    field :projects, Types::ProjectType.connection_type, null: false
    def projects
      AssociationLoader.for(User, :projects).load(object).then(&:to_ary)
    end
  end
end
