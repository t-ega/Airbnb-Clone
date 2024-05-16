module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identify_by :current_user

    def connect
      puts "Tryhingg"
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if (verified_user = env['warden'].user)
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
