# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged, slug_column: :permalink

  belongs_to :user
  belongs_to :category
  belongs_to :danmakufu_version
  has_many_attached :images
  has_one_attached :archive

  has_many :legacy_images,
           as: :attachable,
           class_name: 'Image',
           dependent: :destroy

  has_one :legacy_archive,
          as: :attachable,
          class_name: 'Archive',
          dependent: :destroy

  # acts_as_taggable_on :tags

  validates_presence_of :title, message: 'Title is required.'
end
