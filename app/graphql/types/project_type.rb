# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    implements GraphQL::Relay::Node.interface

    global_id_field :id

    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :permalink, String, null: true
    field :title, String, null: true
    field :description, String, null: true
    field :downloads, Integer, null: true
    field :draft, Boolean, null: true

    field :user, Types::UserType, null: true
    def user
      AssociationLoader.for(Project, :user).load(object)
    end

    field :category, String, null: true
    def category
      AssociationFieldLoader.for(Project, :category, :name).load(object)
    end

    field :danmakufu_version, String, null: true
    def danmakufu_version
      AssociationFieldLoader.for(Project, :danmakufu_version, :name).load(object)
    end
  end
end
