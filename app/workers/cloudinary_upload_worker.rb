# app/workers/cloudinary_upload_worker.rb
class CloudinaryUploadWorker
  include Sidekiq::Worker

  def perform(car_id, image_url)
    car = Car.find(car_id)
    Cloudinary::Uploader.upload(image_url, public_id: car.id)
    Rails.logger.info "Image uploaded to Cloudinary for Car ID: #{car.id}"
  end
end
