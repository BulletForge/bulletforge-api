# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'UpdateMe mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }
  let(:results) { graphql.update_me(input: input, context: context) }

  describe 'with no current user' do
    let(:context) { {} }
    let(:input)   { {} }

    it 'returns nil on the mutation' do
      expect(results['data']['updateUser']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user that is admin' do
    let(:current_user) { create :random_user }
    let(:context)      { { current_user_id: current_user.id } }

    describe 'when user validations pass' do
      let(:new_login) { Faker::Name.unique.first_name }
      let(:input)     { { login: new_login } }

      it 'updates the user' do
        # TODO: Figure out how to trigger the query without this hack
        results['data']

        current_user.reload
        expect(current_user.login).to eq(new_login)
      end

      it 'returns the updated user' do
        expect(results['data']['updateMe']['user']).not_to eq(nil)
      end

      it 'does not return errors' do
        expect(results['errors']).to eq(nil)
      end
    end

    describe 'when user validations fail' do
      let(:input) do
        {
          password: Faker::Internet.unique.password,
          password_confirmation: Faker::Internet.unique.password
        }
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
