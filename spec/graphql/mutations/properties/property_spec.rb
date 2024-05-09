require "rails_helper"

RSpec.describe Property, type: :request do
  describe ".resolve" do
    let!(:host) { FactoryBot.create(:user) }
    let!(:token) { AuthService.sign_user(host) }

    it "should create a property successfully" do
      property_params = {
        name: "Dummy Listing",
        headline: "Amazing Property for Rent",
        description:
          "Beautiful and spacious property available for rent. Don't miss out!",
        address: "123 Main Street",
        city: "Dummy City",
        price: 100.45,
        state: "Dummy State",
        country: "Dummy Country"
      }

      expect do
        post "/graphql",
             params: {
               query: create_query(**property_params)
             },
             headers: {
               Authorization: "Bearer #{token}"
             }
      end.to change { Property.count }.by(1)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.dig(:data, :createProperty, :property, :name)).to eq(
        property_params.dig(:name)
      )
      expect(data.dig(:data, :createProperty, :property, :price)).to eq(
        property_params.dig(:price)
      )
    end

    it "should return an error if required parameters are missing" do
      property_params = {
        # Missing some required parameters
        headline: "Amazing Property for Rent",
        description:
          "Beautiful and spacious property available for rent. Don't miss out!",
        address: "123 Main Street",
        city: "Dummy City",
        price: 100.45,
        state: "Dummy State",
        country: "Dummy Country"
      }

      expect do
        post "/graphql",
             params: {
               query: create_query(**property_params)
             },
             headers: {
               Authorization: "Bearer #{token}"
             }
      end.not_to change { Property.count }

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.dig(:errors)).to be_an(Array)
      expect(data.dig(:errors).first.dig(:extensions, :code)).to include(
        ErrorCodes.unprocessable_entity
      )
    end

    it "should return an error if the user is not authorized" do
      property_params = {
        name: "Dummy Listing",
        headline: "Amazing Property for Rent",
        description:
          "Beautiful and spacious property available for rent. Don't miss out!",
        address: "123 Main Street",
        city: "Dummy City",
        price: 100.45,
        state: "Dummy State",
        country: "Dummy Country"
      }

      expect do
        post "/graphql",
             params: {
               query: create_query(**property_params)
             },
             headers: {
               Authorization: "Bearer INVALID_TOKEN"
             }
      end.not_to change { Property.count }

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.dig(:errors)).to be_an(Array)
      expect(data.dig(:errors).first.dig(:extensions, :code)).to include(
        ErrorCodes.unauthorized
      )
    end
  end

  def create_query(**args)
    name = args[:name]
    headline = args[:headline]
    description = args[:description]
    address = args[:address]
    city = args[:city]
    price = args[:price]
    state = args[:state]
    country = args[:country]

    <<~GQL
      mutation {
        createProperty(
            name: "#{name}",
            headline: "#{headline}",
            description: "#{description}",
            address: "#{address}",
            city: "#{city}",
            price: #{price},
            state: "#{state}",
            country: "#{country}"
        ) {
        property{
          id 
          name
          headline
          description
          address
          city
          price
          host{
          id
          }
          state
          country
        }
        }
      }
    GQL
  end
end
