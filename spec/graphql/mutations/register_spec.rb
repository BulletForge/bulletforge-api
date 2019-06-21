# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Register mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }
  let(:results) { graphql.register(input: input) }

  describe 'when passing invalid arguments' do
    let(:input) { {} }

    it 'returns no data' do
      expect(results['data']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'when passing valid arguments' do
    let(:input) do
      {
        login: login,
        email: email,
        password: password,
        password_confirmation: password
      }
    end

    describe 'when user validations pass' do
      let(:login)    { Faker::Name.first_name }
      let(:email)    { Faker::Internet.email }
      let(:password) { Faker::Internet.password }

      it 'creates the user' do
        permalink = results['data']['register']['user']['permalink']
        expect { User.friendly.find(permalink) }.not_to raise_error
      end

      it 'returns the created user' do
        expect(results['data']['register']['user']).not_to eq(nil)
      end

      it 'does not return errors' do
        expect(results['errors']).to eq(nil)
      end
    end

    describe 'when user validations fail' do
      let(:login)    { Faker::Name.first_name }
      let(:email)    { '' }
      let(:password) { Faker::Internet.password }

      it 'returns nil on the mutation' do
        expect(results['data']['register']).to eq(nil)
      end

      it 'returns errors' do
        expect(results['errors']).not_to be_empty
      end
    end
  end
end
