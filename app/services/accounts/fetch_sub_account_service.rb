module Accounts
  class FetchSubAccountService < ApplicationService
    def initialize(host_id)
      secret_key = ENV["QUIDAX_SECRET_KEY"]
      @quidax_object = Quidax.new(secret_key)
      @quidax_user = QuidaxUser.new(@quidax_object)
      @host_id = host_id
    end

    def call
    end
  end
end
