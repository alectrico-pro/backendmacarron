FactoryBot.define do
  factory :admin do
    name { Faker::StarWars.character }
    email{ Faker::Internet.email }
    fono { Faker::PhoneNumber.phone_number }
    password_digest { "1aB%EFGH" }
    admin { true }
#    password_digest {Faker::Internet.password( 9,  10, true,true) }

  end
end
