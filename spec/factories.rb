FactoryGirl.define do

  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    password 'password'
  end

  factory :trait do
    name { Faker::Lorem.word }
  end

  factory :food do
    name { Faker::Lorem.word }
  end
end
