require 'cloudinary'
require 'cloudinary/api'

begin
  resources = Cloudinary::Api.resources(type: :upload, max_results: 500)
  resources['resources'].each do |resource|
    Cloudinary::Api.delete_resources(resource['public_id'])
    puts "Deleted: #{resource['public_id']}"
  end
rescue Cloudinary::Api::Error => e
  puts "An error occurred: #{e.message}"
end
