# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when validating on save' do
    let(:user) { build(:random_user) }

    it 'ensures login exists' do
      user.login = nil
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures email exists' do
      user.email = nil
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures email is formatted as an email' do
      user.email = 'hi'
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures password exists' do
      user.password = nil
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures password confirmation exists' do
      user.password_confirmation = nil
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures password confirmation matches password' do
      user.password_confirmation = 'a'
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'saves successfully when validations pass' do
      expect(user.save).to eq(true)
    end
  end
end
