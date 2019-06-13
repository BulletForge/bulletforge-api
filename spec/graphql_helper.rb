# frozen_string_literal: true

require 'gqli/dsl'

class GraphqlHelper
  extend GQLi::DSL
  include GQLi::DSL

  UserFields = fragment('UserFields', 'User') {
    id
    login
    email
  }

  UsersPageFields = fragment('UsersPageFields', 'User') {
    edges {
      cursor
      node {
        ___ UserFields
      }
    }
  }

  def users(**args)
    q = users_query(**args).to_s
    BulletforgeApiSchema.execute q
  end

  def user(id:)
    q = user_query(id: id).to_s
    BulletforgeApiSchema.execute q
  end

  private

  def users_query(**args)
    page_args = args.slice(:first, :last, :before, :after)

    query {
      __node('users', **page_args) {
        ___ UsersPageFields
      }
    }
  end

  def user_query(id:)
    query {
      __node('user', id: id) {
        ___ UserFields
      }
    }
  end
end
