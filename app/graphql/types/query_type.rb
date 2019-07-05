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
      RecordLoader.for(User, column: :permalink).load(permalink)
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end

    field :projects, Types::ProjectType.connection_type, null: false do
      argument :sort_by, Types::ProjectSort, required: false
      argument :sort_direction, Types::SortDirection, required: false
    end
    def projects(sort_by: :created_at, sort_direction: :desc)
      Project.order(sort_by => sort_direction)
    end

    field :me, Types::UserType, null: true
    def me
      RecordLoader.for(User).load(context[:current_user_id])
    end
  end
end
