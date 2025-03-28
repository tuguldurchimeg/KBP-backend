class V1::S3Controller < ApplicationController
  before_action :authorize_request

  DOCUMENTS = 'documents'
  AVATAR = 'avatar'
  FILES = 'files'

  def presigned_url
    file_name = params[:file_name]
    mime_type = params[:mime_type]
    content_type = params[:content_type]

    return respond('Missing parameter file_name', :unprocessable_entity) unless file_name.present?
    return respond('Missing parameter content_type', :unprocessable_entity) unless content_type.present?
    return respond('Missing parameter mime_type', :unprocessable_entity) unless mime_type.present?

    system_setting = Base::MstSystemSetting.find_by(name: 'company_prefix')
    bucket_folder = system_setting&.value.to_s

    case content_type
    when AVATAR
      # jishee: avatar/user_23/profile.png
      bucket_folder += "/avatar/user_#{@current_user.id}"

    when DOCUMENTS
      document_id = params[:document_id]
      return respond('Missing parameter document_id', :unprocessable_entity) unless document_id.present?

      # jishee: documents/456/files/user_23/filename
      bucket_folder += "/documents/#{document_id}/files/user_#{@current_user.id}"

    when FILES
      bucket_folder += "/files/user_#{@current_user.id}/#{Time.now.strftime('%Y/%m')}"

    else
      return respond("Invalid content_type. Must be 'avatar', 'files', or 'documents'", :unprocessable_entity)
    end

    file_name = "#{Time.now.to_i}_#{file_name}"
    full_key = "#{bucket_folder}/#{file_name}"

    render json: create_presigned_url(full_key, mime_type)
  end

  private

  def create_presigned_url(key, mime_type, acl = 'public-read')
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(ENV['S3_BUCKET_NAME'])
    obj = bucket.object(key)

    presigned_url = obj.presigned_url(
      :put,
      content_type: mime_type,
      expires_in: 1800,
      acl: acl
    )

    {
      upload_url: presigned_url,
      file_url: obj.public_url,
      key: key,
      file_name: File.basename(key)
    }
  end
end
