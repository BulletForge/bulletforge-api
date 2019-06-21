# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'DestroyUser mutation', type: :feature do
  let(:graphql)    { GraphqlHelper.new }
  let(:results)    { graphql.destroy_user(input: input, context: context) }
  let(:data)    { results['data']['destroyUser'] }
  let(:errors)  { results['errors'] }

  describe 'with no current user' do
    let(:context) { {} }
    let(:input)   { {} }

    it 'returns false on success' do
      expect(data['success']).to eq(false)
    end

    it 'does not return top level errors' do
      expect(errors).to eq(nil)
    end

    it 'returns errors as data' do
      expect(data['errors']).not_to be_empty
    end
  end

  describe 'with a current user that isn\'t an admin' do
    let(:current_user) { create :random_user }
    let(:context)      { { current_user_id: current_user.id } }

    describe 'with invalid arguments' do
      let(:input) { {} }

      it 'returns false on success' do
        expect(data['success']).to eq(false)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'returns errors as data' do
        expect(data['errors']).not_to be_empty
      end
    end

    describe 'with valid arguments' do
      let(:other_user) { create :random_user }
      let(:user_id)    { graphql.user(permalink: other_user.permalink)['data']['user']['id'] }
      let(:input)      { { user_id: user_id } }

      it 'returns false on success' do
        expect(data['success']).to eq(false)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'returns errors as data' do
        expect(data['errors']).not_to be_empty
      end
    end
  end

  describe 'with a current user that is an admin' do
    let(:current_user) { create :random_admin }
    let(:context)      { { current_user_id: current_user.id } }

    describe 'with invalid arguments' do
      let(:input) { {} }

      it 'returns false on success' do
        expect(data['success']).to eq(false)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'returns errors as data' do
        expect(data['errors']).not_to be_empty
      end
    end

    describe 'with valid arguments' do
      let(:other_user) { create :random_user }
      let(:user_id)    { graphql.user(permalink: other_user.permalink)['data']['user']['id'] }
      let(:input)      { { user_id: user_id } }

      it 'destroys the user' do
        # Trigger lazy resolution
        data
        expect { User.find(other_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns success' do
        expect(data['success']).to eq(true)
      end

      it 'does not return top level errors' do
        expect(errors).to eq(nil)
      end

      it 'does not return errors as data' do
        expect(data['errors']).to be_empty
      end
    end
  end
end
