# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Update user mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }

  describe 'with no current user' do
    let(:results) do
      input = { id: 'test' }
      graphql.update_user(input: input)
    end

    it 'returns nil on the mutation' do
      expect(results['data']['updateUser']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user' do
    let(:user) { create :random_user }
    let(:context) { { current_user: user } }

    describe 'when failing authorization' do
      let(:results) do
        input = { id: 'not_the_current_user' }
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
        input = {
          id: user.friendly_id,
          login: new_login
        }
        graphql.update_user(input: input, context: context)
      end

      it 'updates the user' do
        friendly_id = results['data']['updateUser']['user']['id']
        expect(User.friendly.find(friendly_id).login).to eq(new_login)
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
        input = {
          id: user.friendly_id,
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
