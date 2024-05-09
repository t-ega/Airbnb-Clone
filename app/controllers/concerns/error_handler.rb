module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      flash[:alert] = "The requested resource could not be found"
      redirect_to root_path
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render flash[:alert] = e.record.errors
      end

  end


end