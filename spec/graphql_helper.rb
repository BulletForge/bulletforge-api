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
    q = users_query(camelize_keys(**args)).to_s
    BulletforgeApiSchema.execute q
  end

  def user(id:)
    q = user_query(id: id).to_s
    BulletforgeApiSchema.execute q
  end

  def create_user(input: {})
    q = create_user_mutation(input: camelize_keys(input)).to_s
    BulletforgeApiSchema.execute q
  end

  private

  def camelize_keys(obj)
    case obj
    when Hash
      new_hsh = {}
      obj.each do |k, v|
        new_hsh[k.to_s.camelize(:lower).to_sym] = camelize_keys(v)
      end
      new_hsh
    when Array
      obj.map(&:camelize_keys)
    else
      obj
    end
  end

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

  def create_user_mutation(input:)
    mutation {
      createUser(input: input) {
        user {
          ___ UserFields
        }
      }
    }
  end
end
