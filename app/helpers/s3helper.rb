module S3Helper
  def self.cdn_url(key)
    return nil if key.blank?
    "#{AWS_CDN}#{key}"
  end

    # 150x150
  def self.thumbnail_url(key)
    resize_variant_url(key, '150x150')
  end

  # 600x600
  def self.medium_url(key)
    resize_variant_url(key, '600x600')
  end

  # 1024x768
  def self.cover_url(key)
    resize_variant_url(key, '1024x768')
  end

  def self.article_file_path(document_id, user_id, file_name)
    "documents/#{document_id}/files/user_#{user_id}/#{timestamped(file_name)}"
  end

  def self.avatar_path(user_id, file_name)
    "avatar/user_#{user_id}/#{timestamped(file_name)}"
  end

  def self.user_file_path(user_id, file_name)
    "files/user_#{user_id}/#{Time.now.strftime('%Y/%m')}/#{timestamped(file_name)}"
  end

  private

  def self.resize_variant_url(key, size_suffix)
    return nil if key.blank?

    dir, filename = File.split(key)
    base, ext = File.basename(filename, '.*'), File.extname(filename)
    variant_name = "#{base}-#{size_suffix}#{ext}"
    full_path = File.join(dir, variant_name)

    "#{AWS_RESIZE_CDN}#{full_path}"
  end

  def self.timestamped(file_name)
    "#{Time.now.to_i}_#{file_name}"
  end
end
