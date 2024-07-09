# app/workers/cloudinary_upload_worker.rb
class CloudinaryUploadWorker
  include Sidekiq::Worker

  def perform(car_id, image_url)
    car = Car.find(car_id)
    image_path = ActiveStorage::Blob.service.send(:path_for, car.image.key)
    Cloudinary::Uploader.upload(image_url, public_id: car.image.filename.base)
    Rails.logger.info "Image uploaded to Cloudinary: #{car.image.filename}"
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Car with id=#{car_id} not found."
  rescue StandardError => e
    Rails.logger.error "An error occurred: #{e.message}"
  end
end
