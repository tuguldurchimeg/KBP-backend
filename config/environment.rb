# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
DEFAULT_PASSWORD = 'Test@123'
ORDER_OPTIONS = %w[asc desc]
UTC_TIMEZONE = 'Etc/UTC'
MONTHS_IN_YEAR = 12
SECONDS_IN_DAY = 86_400.0
SECONDS_IN_HOUR = 3600.0
DEFAULT_TIME = '00:00:00'
AWS_CDN = "https://#{ENV['S3_BUCKET_NAME']}.s3.ap-northeast-1.amazonaws.com/"
AWS_RESIZE_CDN = "https://#{ENV['S3_BUCKET_NAME']}-resized.s3.ap-northeast-1.amazonaws.com/"
