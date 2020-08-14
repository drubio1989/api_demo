FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    article
    user
  end
end
