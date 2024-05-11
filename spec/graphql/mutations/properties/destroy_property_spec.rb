require "rails_helper"

RSpec.describe Property, type: :request do
  describe "delete" do
    let!(:host) { FactoryBot.create(:user) }
    let!(:token) { AuthService.sign_user(host) }
    let!(:property) { FactoryBot.create(:property, host: host) }

    it "should delete a property successfully" do
      expect do
        post "/graphql",
             params: {
               query: query(id: property.id)
             },
             headers: {
               Authorization: "Bearer #{token}"
             }
      end.to change { Property.count }.from(1).to(0)

      expect { property.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return an error if the user deleting is not a host" do
      host_2 = FactoryBot.create(:user)
      token = AuthService.sign_user(host_2)

      expect do
        post "/graphql",
             params: {
               query: query(id: property.id)
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

      property.reload

      expect(property.persisted?).to be_truthy
    end

    def query(**args)
      id = args[:id]

      <<~GQL
      mutation {
        destroyProperty(
            input: { id: #{id} }
        ) {
        status
        }
      }
    GQL
    end
  end
end
