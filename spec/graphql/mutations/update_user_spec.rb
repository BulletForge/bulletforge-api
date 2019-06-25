# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'UpdateUser mutation', type: :feature do
  let(:graphql)    { GraphqlHelper.new }
  let(:raw_data)   { graphql.update_user(input: input, context: context) }
  let(:data)       { raw_data['data'] }
  let(:errors)     { raw_data['errors'] }
  let(:results)    { data['updateUser'] }

  let(:other_user) { create :random_user }
  let(:user_id)    { graphql.user(permalink: other_user.permalink)['data']['user']['id'] }

  describe 'with invalid arguments' do
    let(:input)   { {} }
    let(:context) { {} }

    it 'returns nil on returned data' do
      expect(data).to eq(nil)
    end

    it 'returns top level errors' do
      expect(errors).not_to eq(nil)
    end
  end

  describe 'with no current user' do
    let(:context) { {} }
    let(:input)   { { user_id: user_id } }

    it 'returns nil on user' do
      expect(results['user']).to eq(nil)
    end

    it 'does not return top level errors' do
      expect(errors).to eq(nil)
    end

    it 'returns errors as data' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user that isn\'t admin' do
    let(:current_user) { create :random_user }
    let(:context)      { { current_user_id: current_user.id } }
    let(:input)        { { user_id: user_id } }

    it 'returns nil on user' do
      expect(results['user']).to eq(nil)
    end

    it 'does not return top level errors' do
      expect(errors).to eq(nil)
    end

    it 'returns errors as data' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user that is admin' do
    let(:current_user) { create :random_admin }
    let(:context)      { { current_user_id: current_user.id } }

    describe 'when user validations pass' do
      let(:new_login) { Faker::Name.unique.first_name }
      let(:input)     { { user_id: user_id, login: new_login } }

      it 'updates the user' do
        # Trigger lazy resolution
        raw_data

        other_user.reload
        expect(other_user.login).to eq(new_login)
      end

      it 'returns the updated user' do
        expect(results['user']).not_to eq(nil)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'does not return errors as data' do
        expect(results['errors']).to be_empty
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
        expect(results['user']).to eq(nil)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'returns errors as data' do
        expect(results['errors']).not_to be_empty
      end
    end
  end
end
