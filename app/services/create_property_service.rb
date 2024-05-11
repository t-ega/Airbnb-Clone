class CreatePropertyService < ApplicationService
  def initialize(property_params)
    @property_params = property_params
  end

  def call
    property = Property.create(@property_params)
    CreateSubAccountService.call() if property.valid?
  end
end
