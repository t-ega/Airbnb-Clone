# Todo: Use Rails upsert_all feature for bulk updates

3.times do
  password = Faker::Internet.password

  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: password ,
    password_confirmation: password
  )

end

users_ids = User.pluck(:id)
10.times do

  property = Property.create!(
      name: "#{Faker::Address.community} #{Faker::Company.buzzword} #{Faker::Address.street_suffix}",
      headline: Faker::Lorem.sentence(word_count: 40),
      description: Faker::Lorem.paragraph(sentence_count: 10),
      address: Faker::Address.street_address,
      city: Faker::Address.city,
      price:Faker::Commerce.price,
      host_id: users_ids.sample,
      state: Faker::Address.state,
      country: Faker::Address.country
  )

  (1..5).to_a.sample.times do
    Review.create!(reviewable: property, reviewer_id: users_ids.sample, rating: (1..5).to_a.sample, title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph)
  end

end
