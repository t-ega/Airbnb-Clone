module Properties
  class PropertiesController < ApplicationController
    before_action :ensure_user_is_logged_in, only: %i[new create index edit]
    before_action :set_property, only: %i[edit update]

    def show
      @property = Property.includes(:reviews).find(params[:id])
    end

    def new
      @property = Property.new
    end

    def edit
    end

    def update
      @property.update(property_params.except(:image))
      if @property.save
        image = property_params.dig(:image)
        Property.upload_image(image, @property.id) if image.present?
        redirect_to property_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def index
      @properties = Property.where(host: current_user)
      @host = current_user.full_name.capitalize
    end

    def create
      @property = Property.new(property_params.except(:image).merge!(host: current_user))
      image = property_params.dig(:image)
      if @property.save
        # This passes the image upload to a service that uploads the image and store the
        # url back into the image_url column.
        # There is a small trade off here, if the upload is unsuccessful we are not going to delete
        # the property from the database, the client would have to re-upload
        Property.upload_image(image, @property.id)
        redirect_to property_path(@property)
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def property_params
      params.require(:property).permit(:name, :description, :price, :headline, :city, :state, :image, :country, :address)
    end

    def set_property
      @property = Property.find(params[:id])
    end

  end
end
