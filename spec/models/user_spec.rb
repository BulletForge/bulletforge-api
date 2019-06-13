# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  ######
  # Validations on create
  ######
  context 'when validating on create' do
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

    it 'ensures login is unique' do
      user2 = build(:random_user)
      user2.login = user.login
      user.save!

      expect { user2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures email is unique' do
      user2 = build(:random_user)
      user2.email = user.email
      user.save!

      expect { user2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  ######
  # Validations on update
  ######
  context 'when validating on update' do
    let(:user) { create(:random_user) }

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

    it 'does not ensure password and password_confirmation exist' do
      user.password = nil
      user.password_confirmation = nil
      expect { user.save! }.not_to raise_error
    end

    it 'ensures password_confirmation exists if password does' do
      user.password = 'newpasswordyay'
      user.password_confirmation = nil
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures password confirmation matches password' do
      user.password = 'newpasswordyay'
      user.password_confirmation = 'a'
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures login is unique' do
      user2 = create(:random_user)
      user2.login = user.login

      expect { user2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'ensures email is unique' do
      user2 = create(:random_user)
      user2.email = user.email

      expect { user2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  ######
  # Extra data populated on save
  ######
  context 'when successfully saved' do
    let(:user) { create(:random_user) }

    it 'creates a permalink' do
      expect(user.permalink).not_to be_nil
    end
  end
end
