class CloudinaryUploadWorker
  include Sidekiq::Worker

  def perform(car_id, image_url)
    car = Car.find(car_id)
    response = Cloudinary::Uploader.upload(image_url, public_id: car.id)
    car.update(image_url: response['secure_url']) if response
  rescue => e
    Rails.logger.error "CloudinaryUploadWorker Error: #{e.message}"
  end
end
