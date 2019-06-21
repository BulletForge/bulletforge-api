# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'UpdateUser mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }
  let(:results) { graphql.update_user(input: input, context: context) }
  let(:data)    { results['data']['updateUser'] }
  let(:errors)  { results['errors'] }

  describe 'with no current user' do
    let(:input)   { { user_id: 'test' } }
    let(:context) { {} }

    it 'returns nil on user' do
      expect(data['user']).to eq(nil)
    end

    it 'does not return top level errors' do
      expect(errors).to eq(nil)
    end

    it 'returns errors as data' do
      expect(data['errors']).not_to be_empty
    end
  end

  describe 'with a current user that isn\'t admin' do
    let(:current_user) { create :random_user }
    let(:user_id)      { graphql.user(permalink: current_user.permalink)['data']['user']['id'] }
    let(:input)        { { user_id: user_id } }
    let(:context)      { { current_user_id: current_user.id } }

    it 'returns nil on user' do
      expect(data['user']).to eq(nil)
    end

    it 'does not return top level errors' do
      expect(errors).to eq(nil)
    end

    it 'returns errors as data' do
      expect(data['errors']).not_to be_empty
    end
  end

  describe 'with a current user that is admin' do
    let(:current_user) { create :random_admin }
    let(:user_id)      { graphql.user(permalink: current_user.permalink)['data']['user']['id'] }
    let(:context)      { { current_user_id: current_user.id } }

    describe 'when user validations pass' do
      let(:new_login) { Faker::Name.unique.first_name }
      let(:input)     { { user_id: user_id, login: new_login } }

      it 'updates the user' do
        # Trigger lazy resolution
        data

        current_user.reload
        expect(current_user.login).to eq(new_login)
      end

      it 'returns the updated user' do
        expect(data['user']).not_to eq(nil)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'does not return errors as data' do
        expect(data['errors']).to be_empty
      end
    end

    describe 'when user validations fail' do
      let(:input) do
        {
          user_id: user_id,
          password: Faker::Internet.unique.password,
          password_confirmation: Faker::Internet.unique.password
        }
      end

      it 'returns nil on user' do
        expect(data['user']).to eq(nil)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'returns errors as data' do
        expect(data['errors']).not_to be_empty
      end
    end
  end
end
