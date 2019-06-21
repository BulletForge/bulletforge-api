# frozen_string_literal: true

require 'gqli/dsl'

class GraphqlHelper
  extend GQLi::DSL
  include GQLi::DSL

  def user(permalink:)
    q = user_query(permalink: permalink).to_s
    BulletforgeApiSchema.execute q
  end

  def users(**args)
    q = users_query(camelize_keys(**args)).to_s
    BulletforgeApiSchema.execute q
  end

  def register(input: {})
    q = register_mutation(input: camelize_keys(input)).to_s
    BulletforgeApiSchema.execute q
  end

  def update_me(input: {}, context: {})
    q = update_me_mutation(input: camelize_keys(input)).to_s
    BulletforgeApiSchema.execute(q, context: context)
  end

  def update_user(input: {}, context: {})
    q = update_user_mutation(input: camelize_keys(input)).to_s
    BulletforgeApiSchema.execute(q, context: context)
  end

  def destroy_user(input: {}, context: {})
    q = destroy_user_mutation(input: camelize_keys(input)).to_s
    BulletforgeApiSchema.execute(q, context: context)
  end

  def login(input: {})
    q = login_mutation(input: camelize_keys(input)).to_s
    BulletforgeApiSchema.execute q
  end

  private

  UserFields = fragment('UserFields', 'User') {
    id
    permalink
    login
    email
    admin
  }

  UsersPageFields = fragment('UsersPageFields', 'User') {
    edges {
      cursor
      node {
        ___ UserFields
      }
    }
  }

  # Recursively camelize the keys in a hash
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

  def user_query(permalink:)
    query {
      __node('user', permalink: permalink) {
        ___ UserFields
      }
    }
  end

  def users_query(**args)
    page_args = args.slice(:first, :last, :before, :after)

    query {
      __node('users', **page_args) {
        ___ UsersPageFields
      }
    }
  end

  def register_mutation(input:)
    mutation {
      register(input: input) {
        user {
          ___ UserFields
        }
      }
    }
  end

  def update_me_mutation(input:)
    mutation {
      updateMe(input: input) {
        user {
          ___ UserFields
        }
      }
    }
  end

  def update_user_mutation(input:)
    mutation {
      updateUser(input: input) {
        user {
          ___ UserFields
        }
      }
    }
  end

  def destroy_user_mutation(input:)
    mutation {
      destroyUser(input: input) {
        success
      }
    }
  end

  def login_mutation(input:)
    mutation {
      login(input: input) {
        token
      }
    }
  end
end
