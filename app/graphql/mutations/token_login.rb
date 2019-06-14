# frozen_string_literal: true

module Mutations
  class TokenLogin < Mutations::BaseMutation
    null true

    field :user, Types::UserType, null: true

    def resolve
      { user: context[:current_user] }
    end
  end
end
