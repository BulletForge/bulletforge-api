# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'DestroyMe mutation', type: :feature do
  let(:graphql)    { GraphqlHelper.new }
  let(:results)    { graphql.destroy_me(context: context) }

  describe 'with no current user' do
    let(:context) { {} }

    it 'returns nil on the mutation' do
      expect(results['data']['destroyMe']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'with a current user' do
    let(:current_user) { create :random_user }
    let(:context)      { { current_user_id: current_user.id } }

    it 'destroys the user' do
      # TODO: Figure out how to trigger the query without this hack
      results['data']
      expect { User.find(current_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns success' do
      expect(results['data']['destroyMe']['success']).to eq(true)
    end

    it 'does not return errors' do
      expect(results['errors']).to eq(nil)
    end
  end
end
