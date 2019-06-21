# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Register mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }
  let(:results) { graphql.register(input: input) }
  let(:data)    { results['data']['register'] }
  let(:errors)  { results['errors'] }

  describe 'when passing invalid arguments' do
    let(:input) { {} }

    it 'returns nil for user' do
      expect(data['user']).to eq(nil)
    end

    it 'does not return top level errors' do
      expect(errors).to eq(nil)
    end

    it 'returns errors as data' do
      expect(data['errors']).not_to be_empty
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
        permalink = data['user']['permalink']
        expect { User.friendly.find(permalink) }.not_to raise_error
      end

      it 'returns the created user' do
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
      let(:login)    { Faker::Name.first_name }
      let(:email)    { '' }
      let(:password) { Faker::Internet.password }

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
