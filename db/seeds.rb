# Todo: Use Rails upsert_all feature for bulk updates
10.times do
  property = Property.create!(
      name: "#{Faker::Address.community} #{Faker::Company.buzzword} #{Faker::Address.street_suffix}",
      headline: Faker::Lorem.sentence(word_count: 40),
      description: Faker::Lorem.paragraph(sentence_count: 10),
      address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country
  )

  (1..5).to_a.sample.times do
    Review.create!(reviewable: property, rating: (1..5).to_a.sample, title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph)
  end

end
