# app/workers/cloudinary_upload_worker.rb
class CloudinaryUploadWorker
  include Sidekiq::Worker

  def perform(car_id)
    car = Car.find(car_id)
    image_path = ActiveStorage::Blob.service.send(:path_for, car.image.key)
    Cloudinary::Uploader.upload(image_path)
    Rails.logger.info "Image uploaded to Cloudinary: #{car.image.filename}"
  end
end
