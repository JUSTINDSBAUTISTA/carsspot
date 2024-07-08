# app/workers/api_call_worker.rb
class ApiCallWorker
  include Sidekiq::Worker

  def perform(api_endpoint, params)
    response = HTTP.post(api_endpoint, json: params)
    # Process the response as needed
    Rails.logger.info "API Call Response: #{response.body.to_s}"
  end
end
