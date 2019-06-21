# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateUserPolicy do
  let(:other_user) { create :random_user }
  let(:policy) { described_class.new(current_user) }

  describe 'when current_user is an admin' do
    let(:current_user) { create :random_admin }

    it 'will be authorized' do
      expect(policy.authorized?).to be(true)
    end
  end

  describe 'when current user is not an admin' do
    let(:current_user) { create :random_user }

    it 'will not be authorized' do
      expect(policy.authorized?).to be(false)
    end
  end
end
