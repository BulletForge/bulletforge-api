# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId

  friendly_id :login, use: :slugged, slug_column: :permalink

  belongs_to :user
  belongs_to :category
  belongs_to :danmakufu_version
  has_many   :images,  as: :attachable, dependent: :destroy
  has_one    :archive, as: :attachable, dependent: :destroy

  # acts_as_taggable_on :tags

  validates_presence_of :title, message: 'Title is required.'
  validates_presence_of :version_number, message: 'Version number is required.'

  def self.most_downloaded
    joins(:archive).publically_viewable.order('downloads DESC').limit(5)
  end

  def self.latest
    joins(:archive).publically_viewable.order('created_at DESC').limit(5)
  end
end
