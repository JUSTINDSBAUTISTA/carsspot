require 'open-uri'

class CloudinaryUploadWorker
  include Sidekiq::Worker

  def perform(car_id, image_url)
    begin
      car = Car.find(car_id)
      file = URI.open(image_url)
      upload = Cloudinary::Uploader.upload(file.path)
      car.update(image_url: upload['url'])
      puts "Uploaded to Cloudinary: #{upload['url']}"
    rescue => e
      Rails.logger.error "CloudinaryUploadWorker failed: #{e.message}"
    end
  end
end
