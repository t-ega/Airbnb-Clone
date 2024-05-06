# frozen_string_literal: true

class ErrorCodes
  class << self
    def unauthorized
      'AUTHENTICATION_ERROR'
    end

    def invalid_credentials
      'INVALID_CREDENTIALS'
    end

    def inactive_account
      'INACTIVE_ACCOUNT'
    end

    def unprocessable_entity
      'UNPROCESSABLE_ENTITY'
    end
  end
end
