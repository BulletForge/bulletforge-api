# frozen_string_literal: true

# Legacy archive class, read only
class Archive < LegacyAsset
  def url
    "https://s3.amazonaws.com/#{s3_bucket}/#{s3_key}"
  end
end
