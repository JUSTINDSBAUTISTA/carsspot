module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.id
      logger.info "Connected to ActionCable: #{current_user.id}"
    end

    private

    def find_verified_user
      env['warden'].user || reject_unauthorized_connection
    end
  end
end
