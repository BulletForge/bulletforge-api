# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Graphql root users field', type: :feature do
  before do
    create_list :random_user, 10
  end

  after do
    User.destroy_all
  end

  describe 'when doing a query with no arguments' do
    let(:result) { BulletforgeApiSchema.execute(users_query) }

    it 'returns multiple users' do
      expect(result['data']['users']['edges'].count).to eq(10)
    end
  end

  describe 'when doing a query with pagination queries from the front' do
    let(:page_result1) { BulletforgeApiSchema.execute users_query(first: 2) }

    it 'understands first param' do
      expect(page_result1['data']['users']['edges'].count).to eq(2)
    end

    it 'understands first and after params' do
      page_ids1 = page_result1['data']['users']['edges'].map { |user| user['node']['id'] }
      cursor = page_result1['data']['users']['edges'].last['cursor']

      page_result2 = BulletforgeApiSchema.execute users_query(first: 2, after: cursor)
      page_ids2 = page_result2['data']['users']['edges'].map { |user| user['node']['id'] }

      expect(page_ids1 & page_ids2).to be_empty
    end
  end

  describe 'when doing a query with pagination queries from the back' do
    let(:page_result1) { BulletforgeApiSchema.execute users_query(last: 2) }

    it 'understands last param' do
      expect(page_result1['data']['users']['edges'].count).to eq(2)
    end

    it 'understands last and before params' do
      page_ids1 = page_result1['data']['users']['edges'].map { |user| user['node']['id'] }
      cursor = page_result1['data']['users']['edges'].first['cursor']

      page_result2 = BulletforgeApiSchema.execute users_query(last: 2, before: cursor)
      page_ids2 = page_result2['data']['users']['edges'].map { |user| user['node']['id'] }

      expect(page_ids1 & page_ids2).to be_empty
    end
  end

  def users_query(**args)
    query = GQLi::DSL.query {
      users(**args) {
        edges {
          cursor
          node {
            id
            email
            login
            projects {
              edges {
                node {
                  id
                }
              }
            }
          }
        }
      }
    }

    query.to_s
  end
end
