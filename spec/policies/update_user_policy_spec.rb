# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateUserPolicy do
  describe 'when current_user is an admin' do
    let(:current_user) { create :random_admin }

    describe 'when updating self' do
      let(:policy) { described_class.new(current_user, current_user, {}) }

      it 'will be authorized' do
        expect(policy.authorized?).to be(true)
      end
    end

    describe 'when updating other user' do
      let(:other_user) { create :random_user }
      let(:policy) { described_class.new(current_user, other_user, {}) }

      it 'will be authorized' do
        expect(policy.authorized?).to be(true)
      end
    end

    describe 'when updating admin on self' do
      let(:policy) { described_class.new(current_user, current_user, admin: false) }

      it 'will be authorized' do
        expect(policy.authorized?).to be(true)
      end
    end

    describe 'when updating admin on other user' do
      let(:other_user) { create :random_user }
      let(:policy) { described_class.new(current_user, other_user, admin: true) }

      it 'will be authorized' do
        expect(policy.authorized?).to be(true)
      end
    end
  end

  describe 'when current user is not an admin' do
    let(:current_user) { create :random_user }

    describe 'when updating self' do
      let(:policy) { described_class.new(current_user, current_user, {}) }

      it 'will be authorized' do
        expect(policy.authorized?).to be(true)
      end
    end

    describe 'when updating other user' do
      let(:other_user) { create :random_user }
      let(:policy) { described_class.new(current_user, other_user, {}) }

      it 'will no be authorized' do
        expect(policy.authorized?).to be(false)
      end
    end

    describe 'when updating admin on self' do
      let(:policy) { described_class.new(current_user, current_user, admin: true) }

      it 'will no be authorized' do
        expect(policy.authorized?).to be(false)
      end
    end

    describe 'when updating admin on other user' do
      let(:other_user) { create :random_user }
      let(:policy) { described_class.new(current_user, other_user, admin: true) }

      it 'will no be authorized' do
        expect(policy.authorized?).to be(false)
      end
    end
  end
end
