# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    add_field GraphQL::Types::Relay::NodeField
    add_field GraphQL::Types::Relay::NodesField

    field :users, Types::UserType.connection_type, null: false
    def users
      User.all
    end

    field :user, Types::UserType, null: false do
      argument :permalink, String, required: true
    end
    def user(permalink:)
      User.friendly.find(permalink)
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end

    field :projects, Types::ProjectType.connection_type, null: false
    def projects
      Project.all
    end

    field :me, Types::UserType, null: false
    def me
      context[:current_user]
    end
  end
end
