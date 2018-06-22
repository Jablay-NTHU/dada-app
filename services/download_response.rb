# frozen_string_literal: true

require 'http'
require 'aws-sdk-s3'

# Returns an authenticated user, or nil
class DownloadResponse
  # Error for inability of API to edit profile
  class InvalidResponse < StandardError
    def message
      'This response cant be download. please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, result)
    content = result.to_s

    file = File.open('download.json', 'w')
      file.write(content)
    file.close()

    s3 = Aws::S3::Client.new(
      access_key_id: @config.AWS_ACCESS_KEY_ID,
      secret_access_key: @config.AWS_SECRET_ACCESS_KEY,
      region: @config.AWS_REGION
    )

    object_key = "#{@config.AWS_DOWNLOAD_FOLDER_NAME}/#{user.username}/download.json"
    result = s3.put_object(bucket: @config.AWS_BUCKET_NAME, key: object_key, body: file)

    # Setting the object to public-read
    s3.put_object_acl({
      acl: "public-read",
      bucket: @config.AWS_BUCKET_NAME,
      key: object_key
    })
    download_url = "#{@config.AWS_S3_URL}/#{@config.AWS_BUCKET_NAME}/#{object_key}"
    return download_url
  end
end
