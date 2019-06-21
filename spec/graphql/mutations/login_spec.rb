# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Login mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }

  describe 'when passing invalid arguments' do
    let(:results) { graphql.login }

    it 'returns no data' do
      expect(results['data']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'when passing valid arguments' do
    describe 'when the credentials are valid' do
      let(:user) { create :random_user }
      let(:input) do
        {
          login: user.login,
          password: user.password
        }
      end
      let(:results) { graphql.login(input: input) }

      it 'returns a token' do
        expect(results['data']['login']['token']).not_to eq(nil)
      end

      it 'does not return errors' do
        expect(results['errors']).to eq(nil)
      end
    end

    describe 'when the credentials are invalid' do
      let(:user) { build :random_user }
      let(:input) do
        {
          login: user.login,
          password: user.password
        }
      end
      let(:results) { graphql.login(input: input) }

      it 'returns nil on the mutation' do
        expect(results['data']['login']).to eq(nil)
      end

      it 'returns errors' do
        expect(results['errors']).not_to be_empty
      end
    end
  end
end
