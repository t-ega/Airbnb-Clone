FactoryBot.define do
  factory :reservation do
    guest_id { 1 }
    property_id { 1 }
    checkin_date { "2024-05-03 19:13:12" }
    checkout_date { "2024-05-03 19:13:12" }
    price { 1 }
  end
end
