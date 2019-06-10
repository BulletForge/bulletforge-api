# frozen_string_literal: true

class User < ApplicationRecord
  has_many :projects, dependent: :destroy

  # has_permalink :login, :update => true, :unique => false
  validates_exclusion_of(
    :permalink,
    in: ['new'],
    message: "Username cannot be 'new'."
  )

  validates_uniqueness_of(
    :permalink,
    message: 'Username is in use by another account.'
  )

  validate :login_excludes_new_by_permalink, :login_is_unique_by_permalink

  def login_excludes_new_by_permalink
    errors.add(:login, "Username cannot be named 'new'.") if
      permalink == 'new'
  end

  def login_is_unique_by_permalink
    user_with_permalink = User.find_by_permalink(permalink)
    errors.add(:login, 'Username is in use by another account.') if
      user_with_permalink && user_with_permalink != self
  end

  def to_param
    permalink
  end
end
