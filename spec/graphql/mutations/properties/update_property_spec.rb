require "rails_helper"

RSpec.describe Property, type: :request do
  describe ".update" do
    let!(:host) { FactoryBot.create(:user) }

    let!(:token) { AuthService.sign_user(host) }

    let!(:property) do
      FactoryBot.create(
        :property,
        headline: "Amazing Property for Rent",
        name: "My Factory property",
        description:
          "Beautiful and spacious property available for rent. Don't miss out!",
        address: Faker::Address.street_address,
        city: "A City",
        state: Faker::Address.state,
        country: Faker::Address.country,
        host: host,
        price: 5
      )
    end

    it "should update a property successfully" do
      property_params = {
        name: "Dummy Listing",
        city: "Dummy City",
        price: 100.45,
        id: property.id
      }

      post "/graphql",
           params: {
             query: query(**property_params)
           },
           headers: {
             Authorization: "Bearer #{token}"
           }

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.dig(:data, :updateProperty, :property, :name)).to eq(
        property_params.dig(:name)
      )
      expect(data.dig(:data, :updateProperty, :property, :city)).to eq(
        property_params.dig(:city)
      )
      expect(data.dig(:data, :updateProperty, :property, :price)).to eq(
        property_params.dig(:price)
      )

      # Reload the property from the database
      property.reload
      expect(property.name).to eq(property_params.dig(:name))
      expect(property.city).to eq(property_params.dig(:city))
      expect(property.price).to eq(property_params.dig(:price))
    end

    it "should return an error if the property ID is invalid " do
      property_params = {
        id: 0,
        name: "Dummy Listing",
        city: "Dummy City",
        price: 100.45
      }

      post "/graphql",
           params: {
             query: query(**property_params)
           },
           headers: {
             Authorization: "Bearer #{token}"
           }

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.dig(:errors)).to be_an(Array)
      expect(data.dig(:errors).first.dig(:extensions, :code)).to include(
        ErrorCodes.not_found
      )

      # Reload the property from the database
      property.reload
      expect(property.name).not_to eq(property_params.dig(:name))
      expect(property.city).not_to eq(property_params.dig(:city))
      expect(property.price).not_to eq(property_params.dig(:price))
    end

    it "should return an error if the user updating is not a host" do
      host_2 = FactoryBot.create(:user)
      token = AuthService.sign_user(host_2)

      property_params = {
        id: property.id,
        name: "Dummy Listing",
        city: "Dummy City",
        price: 100.45
      }

      expect do
        post "/graphql",
             params: {
               query: query(**property_params)
             },
             headers: {
               Authorization: "Bearer #{token}"
             }
      end.not_to change { Property.count }

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.dig(:errors)).to be_an(Array)
      expect(data.dig(:errors).first.dig(:extensions, :code)).to include(
        ErrorCodes.not_found
      )

      # Reload the property from the database
      property.reload
      expect(property.name).not_to eq(property_params.dig(:name))
      expect(property.city).not_to eq(property_params.dig(:city))
      expect(property.price).not_to eq(property_params.dig(:price))
    end
  end

  def query(**args)
    name = args[:name]
    id = args[:id]
    city = args[:city]
    price = args[:price]

    <<~GQL
          mutation {
            updateProperty(
              input: {id: #{id},
                name: "#{name}",
                city: "#{city}",
                price: #{price},
  }
            ) {
            property{
              name
              city
              price
            }
            }
          }
        GQL
  end
end
