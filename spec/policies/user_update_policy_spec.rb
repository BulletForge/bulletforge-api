# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserUpdatePolicy do
  describe 'when user is an admin' do
    let(:user) { create :random_admin }
    let(:policy) { described_class.new(user, {}) }

    it 'will be authorized' do
      expect(policy.authorized?).to be(true)
    end
  end

  describe 'when user is not an admin' do
    let(:user) { create :random_user }

    describe 'when editing self' do
      let(:args) { { id: user.friendly_id } }
      let(:policy) { described_class.new(user, args) }

      it 'will be authorized' do
        expect(policy.authorized?).to be(true)
      end
    end

    describe 'when editing someone else' do
      let(:args) { { id: 'someone_else' } }
      let(:policy) { described_class.new(user, args) }

      it 'will not be authorized' do
        expect(policy.authorized?).to be(false)
      end
    end

    describe 'when editing self and modifying admin' do
      let(:args) { { id: user.friendly_id, admin: true } }
      let(:policy) { described_class.new(user, args) }

      it 'will not be authorized' do
        expect(policy.authorized?).to be(false)
      end
    end
  end
end
