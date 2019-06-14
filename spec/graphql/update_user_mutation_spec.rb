# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Update user mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }

  describe 'with no current user' do
    let(:results) { graphql.update_user(input: { user_id: 'test' }) }

    it 'returns nil on the mutation' do
      expect(results['data']['updateUser']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user' do
    let(:current_user) { create :random_user }
    let(:context) { { current_user: current_user } }

    describe 'when failing authorization' do
      let(:other_user) { create :random_user }
      let(:results) do
        user_id = graphql.user(permalink: other_user.permalink)['data']['user']['id']
        input = { user_id: user_id }
        graphql.update_user(input: input, context: context)
      end

      it 'returns nil on the mutation' do
        expect(results['data']['updateUser']).to eq(nil)
      end

      it 'returns errors' do
        expect(results['errors']).not_to be_empty
      end
    end

    describe 'when user validations pass' do
      let(:new_login) { Faker::Name.unique.first_name }
      let(:results) do
        user_id = graphql.user(permalink: current_user.permalink)['data']['user']['id']
        input = { user_id: user_id, login: new_login }
        graphql.update_user(input: input, context: context)
      end

      it 'updates the user' do
        # TODO: Figure out how to trigger the query without this hack
        results['data']

        current_user.reload
        expect(current_user.login).to eq(new_login)
      end

      it 'returns the updated user' do
        expect(results['data']['updateUser']['user']).not_to eq(nil)
      end

      it 'does not return errors' do
        expect(results['errors']).to eq(nil)
      end
    end

    describe 'when user validations fail' do
      let(:results) do
        user_id = graphql.user(permalink: current_user.permalink)['data']['user']['id']

        input = {
          user_id: user_id,
          password: Faker::Internet.unique.password,
          password_confirmation: Faker::Internet.unique.password
        }
        graphql.update_user(input: input, context: context)
      end

      it 'returns nil on the mutation' do
        expect(results['data']['updateUser']).to eq(nil)
      end

      it 'returns errors' do
        expect(results['errors']).not_to be_empty
      end
    end
  end
end
