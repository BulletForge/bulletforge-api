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

  validates :login, presence: true
  validates :password_confirmation, presence: true, on: :create

  has_many :projects, dependent: :destroy

  def to_param
    permalink
  end
end
