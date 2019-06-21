# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'DestroyUser mutation', type: :feature do
  let(:other_user) { create :random_user }
  let(:user_id)    { graphql.user(permalink: other_user.permalink)['data']['user']['id'] }
  let(:input)      { { user_id: user_id } }
  let(:graphql)    { GraphqlHelper.new }
  let(:results)    { graphql.destroy_user(input: input, context: context) }

  describe 'with no current user' do
    let(:context) { {} }

    it 'returns nil on the mutation' do
      expect(results['data']['destroyUser']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user that isn\'t an admin' do
    let(:current_user) { create :random_user }
    let(:context)      { { current_user_id: current_user.id } }

    it 'returns nil on the mutation' do
      expect(results['data']['destroyUser']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user that is an admin' do
    let(:current_user) { create :random_admin }
    let(:context)      { { current_user_id: current_user.id } }

    describe 'when destruction is successful' do
      it 'destroys the user' do
        # TODO: Figure out how to trigger the query without this hack
        results['data']
        expect { User.find(other_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns success' do
        expect(results['data']['destroyUser']['success']).to eq(true)
      end

      it 'does not return errors' do
        expect(results['errors']).to eq(nil)
      end
    end
  end
end
