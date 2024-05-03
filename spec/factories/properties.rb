FactoryBot.define do
  factory :property do
    name { "MyString" }
    headline { "MyString" }
    description { "MyText" }
    address {"MyString"}
    city { "MyString" }
    state { "MyString" }
    host_id {1}
    country { "MyString" }
  end
end
