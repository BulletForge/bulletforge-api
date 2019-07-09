# frozen_string_literal: true

# Legacy image class, read only
class Image < LegacyAsset
  def s3_key(style = :normal)
    "images/#{id}/#{style}.#{file_extension}"
  end

  def url(style = :normal)
    "https://s3.amazonaws.com/#{s3_bucket}/#{s3_key(style)}"
  end
end
