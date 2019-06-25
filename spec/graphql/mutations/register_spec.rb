# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Register mutation', type: :feature do
  let(:graphql)  { GraphqlHelper.new }
  let(:raw_data) { graphql.register(input: input) }
  let(:data)     { raw_data['data'] }
  let(:errors)   { raw_data['errors'] }
  let(:results)  { data['register'] }

  describe 'when passing invalid arguments' do
    let(:input) { {} }

    it 'returns nil on returned data' do
      expect(data).to eq(nil)
    end

    it 'returns top level errors' do
      expect(errors).not_to eq(nil)
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
        permalink = results['user']['permalink']
        expect { User.friendly.find(permalink) }.not_to raise_error
      end

      it 'returns the created user' do
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
      let(:login)    { Faker::Name.first_name }
      let(:email)    { '' }
      let(:password) { Faker::Internet.password }

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
