FactoryBot.define do
  factory :property do
    name { "MyString" }
    headline { "MyString" }
    description { "MyText" }
    address {"MyString"}
    city { "MyString" }
    state { "MyString" }
    host {FactoryBot.create(:user)}
    country { "MyString" }
  end
end
