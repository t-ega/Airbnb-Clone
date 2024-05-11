module Properties
  class PropertiesController < ApplicationController
    before_action :ensure_user_is_logged_in, only: %i[new create index edit]
    before_action :set_property, only: %i[edit update destroy]

    def show
      @property = Property.includes(:reviews).find(params[:id])
    end

    def new
      @property = Property.new
    end

    def update
      @property.update(property_params.except(:image))
      if @property.save
        image = property_params[:image]
        Property.upload_image(image, @property.id) if image.present?
        return redirect_to property_path
      end

      render :edit, status: :unprocessable_entity
    end

    def destroy
      if @property.destroy
        flash[:notice] = "The listing item was successfully deleted."
        return redirect_to property_path
      end

      flash[:alert] = "The listing could not be deleted."
      redirect_to property_path(@property)
    end

    def index
      @properties = Property.where(host: current_user)
      @host = current_user.full_name.capitalize
    end

    def create
      @property =
        Property.new(property_params.except(:image).merge!(host: current_user))
      image = property_params[:image]
      if @property.valid?
        # This passes the image upload to a service that uploads the image and store the
        # url back into the image_url column.
        # There is a small trade off here, if the upload is unsuccessful we are not going to delete
        # the property from the database, the client would have to re-upload
        Property.upload_image(image, @property.id)

        # Create a sub account on quidax if the user doesnt have an exiting account
        Accounts::CreateSubAccountService.call(current_user.id)
        return redirect_to property_path(@property)
      end

      render :new, status: :unprocessable_entity
    end

    private

    def property_params
      params.require(:property).permit(
        :name,
        :description,
        :price,
        :headline,
        :city,
        :state,
        :image,
        :country,
        :address
      )
    end

    def set_property
      @property = Property.find_by_id_and_host_id(params[:id], current_user)
    end
  end
end
