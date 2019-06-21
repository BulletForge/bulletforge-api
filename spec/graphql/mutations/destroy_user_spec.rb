# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'DestroyUser mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }

  describe 'with no current user' do
    let(:results) { graphql.destroy_user(input: { user_id: 'test' }) }

    it 'returns nil on the mutation' do
      expect(results['data']['destroyUser']).to eq(nil)
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
        graphql.destroy_user(input: { user_id: user_id }, context: context)
      end

      it 'returns nil on the mutation' do
        expect(results['data']['updateUser']).to eq(nil)
      end

      it 'returns errors' do
        expect(results['errors']).not_to be_empty
      end
    end

    describe 'when destruction is successful' do
      let(:results) do
        user_id = graphql.user(permalink: current_user.permalink)['data']['user']['id']
        graphql.destroy_user(input: { user_id: user_id }, context: context)
      end

      it 'destroys the user' do
        # TODO: Figure out how to trigger the query without this hack
        results['data']
        expect { User.find(current_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
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
