class V1::S3Controller < ApplicationController
  before_action :authorize_request

  DOCUMENTS = 'documents'
  AVATAR = 'avatar'
  FILES = 'file'
  WORKSPACE = 'workspace'

  def presigned_url
    file_name = params[:file_name]
    mime_type = params[:mime_type]
    content_type = params[:content_type]

    return respond('Missing parameter file_name', :unprocessable_entity) unless file_name.present?
    return respond('Missing parameter content_type', :unprocessable_entity) unless content_type.present?
    return respond('Missing parameter mime_type', :unprocessable_entity) unless mime_type.present?

    bucket_folder = ''

    case content_type
    when AVATAR
      # jishee: avatar/user_23/profile.png
      bucket_folder += "avatar/user_#{@current_user.id}"

    when DOCUMENTS
      document_id = params[:document_id]
      return respond('Missing parameter document_id', :unprocessable_entity) unless document_id.present?

      # jishee: documents/456/filename
      bucket_folder += "document/#{document_id}"

    when WORKSPACE
      workspace_id = params[:workspace_id]
      return respond('Missing parameter document_id', :unprocessable_entity) unless workspace_id.present?
      bucket_folder += "workspace/#{workspace_id}"

    when FILES
      bucket_folder += "file/company_#{@current_user.company_id}/#{Time.now.strftime('%Y/%m')}"

    else
      return respond("Invalid content_type. Must be 'avatar', 'files', or 'documents'", :unprocessable_entity)
    end
    bucket_folder += "/#{file_name}"
    file_name = "#{Time.now.to_i}-#{file_name}"

    render json: create_presigned_url(bucket_folder, file_name, mime_type)
  end

  private

  def create_presigned_url(folder, file_name, mime_type, acl = 'public-read')
    # key - bucket_folder/object_id/filename
    puts S3_BUCKET.name
    presigned_url = S3_BUCKET.object(folder).presigned_url(
      :put,
      {
				content_type: mime_type,
				expires_in: 1800,
				# acl: acl
			}
    )
		file_url = S3_BUCKET.url + '/' + folder
		{ url: presigned_url, file_url: file_url, file_name: file_name, key: folder }
  end
end
