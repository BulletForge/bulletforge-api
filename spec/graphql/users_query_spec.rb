# frozen_string_literal: true

require 'rails_helper'
require 'graphql_helper'

RSpec.describe 'Root users field', type: :feature do
  before do
    create_list :random_user, 10
  end

  after do
    User.destroy_all
  end

  let(:graphql) { GraphqlHelper.new }

  describe 'with no arguments' do
    let(:result) { graphql.users }

    it 'returns multiple users' do
      expect(result['data']['users']['edges'].count).to eq(10)
    end
  end

  describe 'with pagination arguments from the front' do
    let(:page_result1) { graphql.users(first: 2) }

    it 'understands first argument' do
      expect(page_result1['data']['users']['edges'].count).to eq(2)
    end

    it 'understands first and after arguments' do
      page_ids1 = page_result1['data']['users']['edges'].map { |user| user['node']['id'] }
      cursor = page_result1['data']['users']['edges'].last['cursor']

      page_result2 = graphql.users(first: 2, after: cursor)
      page_ids2 = page_result2['data']['users']['edges'].map { |user| user['node']['id'] }

      expect(page_ids1 & page_ids2).to be_empty
    end
  end

  describe 'with pagination arguments from the back' do
    let(:page_result1) { graphql.users(last: 2) }

    it 'understands last argument' do
      expect(page_result1['data']['users']['edges'].count).to eq(2)
    end

    it 'understands last and before arguments' do
      page_ids1 = page_result1['data']['users']['edges'].map { |user| user['node']['id'] }
      cursor = page_result1['data']['users']['edges'].first['cursor']

      page_result2 = graphql.users(last: 2, before: cursor)
      page_ids2 = page_result2['data']['users']['edges'].map { |user| user['node']['id'] }

      expect(page_ids1 & page_ids2).to be_empty
    end
  end
end
