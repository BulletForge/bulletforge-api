# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'register mutation', type: :feature do
  let(:graphql) { GraphqlHelper.new }

  describe 'when passing invalid arguments' do
    let(:results) { graphql.register }

    it 'returns no data' do
      expect(results['data']).to eq(nil)
    end

    it 'returns errors' do
      expect(results['errors']).not_to be_empty
    end
  end

  describe 'when passing valid arguments' do
    let(:input) do
      pwd = Faker::Internet.password
      {
        login: Faker::Name.first_name,
        email: Faker::Internet.email,
        password: pwd,
        password_confirmation: pwd
      }
    end

    describe 'when user validations pass' do
      let(:results) { graphql.register(input: input) }

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
      let(:results) do
        input[:password_confirmation] = ''
        graphql.register(input: input)
      end

      it 'returns nil on the mutation' do
        expect(results['data']['register']).to eq(nil)
      end

      it 'returns errors' do
        expect(results['errors']).not_to be_empty
      end
    end
  end
end
