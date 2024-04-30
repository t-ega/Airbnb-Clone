require 'rails_helper'

RSpec.describe "Properties", type: :request do
  describe "GET /index" do
    let(:property) {FactoryBot.create(:property, ) }
    it "should succeed" do
      get property_path(property)
      expect(response).to be_successful
    end
  end
end
