# frozen_string_literal: true

# Legacy asset class, read only
class LegacyAsset < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  delegate :user, to: :attachable

  before_save    :deprecated
  before_destroy :deprecated

  def file_extension
    attachment_file_name.split('.').last
  end

  def s3_bucket
    service = Rails.application.config.active_storage.service.to_s
    YAML.load_file('config/storage.yml')[service]['bucket']
  end

  def deprecated
    raise 'Creating, updating, and destroying legacy assets is deprecated'
  end
end
