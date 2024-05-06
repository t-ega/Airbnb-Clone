module Properties
  class PropertiesController < ApplicationController

    def show
      @property = Property.includes(:reviews).find(params[:id])
    end
  end
end
