#
#
# if Rails.env.salon_dev?
#   require 'carrierwave/storage/fog'
#
#   CarrierWave.configure do |config|
#     config.storage = :fog
#
#     config.fog_provider = 'fog/aws' # required
#     config.fog_credentials = {
#         provider: 'AWS', # required
#         aws_access_key_id: Rails.application.credentials.cloud_key, # required
#         aws_secret_access_key: Rails.application.credentials.cloud_access_key, # required
#         region: 'us-east-1', # required
#         endpoint: 'https://storage.yandexcloud.net' # required
#     }
#
#     config.fog_directory = 'saloncentr-storage' # required
#   # config.fog_public = false # optional, defaults to true
#   # config.asset_host = "https://#{config.fog_directory}.ams3.digitaloceanspaces.com"
#     config.asset_host = "https://storage.yandexcloud.net/#{config.fog_directory}"
#     config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' } # optional, defaults to {}
#   end
# end