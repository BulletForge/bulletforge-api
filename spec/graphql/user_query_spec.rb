# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Root user field', type: :feature do
  let(:graphql) { GraphqlHelper.new }

  describe 'when the user exists' do
    let(:user) { create :random_user }
    let(:result) { graphql.user(id: user.permalink) }

    it 'returns the user with matching id' do
      expect(result['data']['user']['id']).to eq(user.permalink)
    end

    it 'returns the user with matching email' do
      expect(result['data']['user']['email']).to eq(user.email)
    end

    it 'returns the user with matching login' do
      expect(result['data']['user']['login']).to eq(user.login)
    end

    it 'does not return an error field' do
      expect(result['errors']).to eq(nil)
    end
  end

  describe 'when the user does not exist' do
    let(:result) { graphql.user(id: 'nonexistant') }

    it 'returns an error field' do
      expect(result['errors']).not_to be_empty
    end
  end
end
