# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId

  friendly_id :login, use: :slugged, slug_column: :permalink

  devise :database_authenticatable,
         :registerable,
         :confirmable,
         :trackable,
         :recoverable,
         :rememberable,
         :validatable

  validates_presence_of :login
  validates_uniqueness_of :login
  validates_presence_of :password_confirmation, if: :password_present?

  has_many :projects, dependent: :destroy

  def to_param
    permalink
  end

  private

  def password_present?
    !password.nil?
  end
end
