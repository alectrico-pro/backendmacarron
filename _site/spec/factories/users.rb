FactoryBot.define do
  factory :user do
    name { Faker::Movies::StarWars.character }
    email{ Faker::Internet.email }
    fono { Faker::PhoneNumber.phone_number }
    password_digest { "1aB%EFGH" }
#    password_digest {Faker::Internet.password( 9,  10, true,true) }

  end
end
