# Todo: Use Rails upsert_all feature for bulk updates
10.times do
  property = Property.create!(
      name: Faker::Lorem.word,
      headline: Faker::Lorem.sentence,
      description: Faker::Lorem.sentence,
      address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country
  )

  (1..5).to_a.sample.times do
    Review.create!(reviewable: property, rating: (1..5).to_a.sample, title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph)
  end

end
