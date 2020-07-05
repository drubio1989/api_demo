FactoryBot.define do
  factory :user do
    login { Faker::Internet.username }
    name { Faker::Name.name }
    url { Faker::Internet.url(host: 'example.com') }
    avatar_url { Faker::Internet.url(host: 'example.com') + '/avatar' }
    provider { "MyString" }
  end
end
