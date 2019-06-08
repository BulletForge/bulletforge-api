# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :danmakufu_version
  has_many   :images,  as: :attachable, dependent: :destroy
  has_one    :archive, as: :attachable, dependent: :destroy

  # acts_as_taggable_on :tags
  # has_permalink :title, :update => true, :unique => false

  validates_presence_of :title, message: 'Title is required.'
  validates_presence_of :version_number, message: 'Version number is required.'
  validate :title_excludes_new_by_permalink, :title_is_unique_by_permalink

  def title_excludes_new_by_permalink
    errors.add(:title, "Title cannot be named 'new'") if
      permalink == 'new'
  end

  def title_is_unique_by_permalink
    project_with_permalink = user.projects.find_by_permalink(permalink)
    errors.add(:title, 'Title is already in use by another project you own.') if
      project_with_permalink && project_with_permalink != self
  end

  def self.most_downloaded
    joins(:archive).publically_viewable.order('downloads DESC').limit(5)
  end

  def self.latest
    joins(:archive).publically_viewable.order('created_at DESC').limit(5)
  end
end
