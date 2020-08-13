FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    content  { Faker::Lorem.paragraph }
    slug { Faker::Internet.slug }
    user
  end
end
