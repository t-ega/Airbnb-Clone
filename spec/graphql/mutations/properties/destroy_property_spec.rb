require "rails_helper"

RSpec.describe Property, type: :request do
  describe "delete" do
    let!(:host) { FactoryBot.create(:user) }
    let!(:token) do
      user = FactoryBot.create(:user)
      AuthService.sign_user(user)
    end
    let(:property) { FactoryBot.create(:property) }

    it "should delete a property successfully" do
      expect do
        post "/graphql",
             params: {
               query: query(**property_params)
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
  end

  def query(**args)
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
