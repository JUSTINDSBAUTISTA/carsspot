# app/workers/cloudinary_upload_worker.rb
class CloudinaryUploadWorker
  include Sidekiq::Worker

  def perform(car_id, image_url)
    logger.info "Performing CloudinaryUploadWorker with car_id=#{car_id} and image_url=#{image_url}"
    car = Car.find(car_id)
    Cloudinary::Uploader.upload(image_url, public_id: car.id)
  rescue ActiveRecord::RecordNotFound
    logger.error "Car with id=#{car_id} not found."
  rescue => e
    logger.error "An error occurred: #{e.message}"
  end
end
