FactoryBot.define do

  factory :instalador, :class => ::Instalador do
    transient do
      confirmar { true }
    end


    usuario
    name { "Instalador: #{Faker::Movies::StarWars.character}" }
    email{ "instalador_#{Faker::Internet.unique.email}" }
    fono { "987654321" }
    password { "123456" }
    password_digest { "123456" }
    instalador { true }
    before(:create) do |instalador, evaluator|
     instalador.confirm if evaluator.confirmar
    end

#    password_digest {Faker::Internet.password( 9,  10, true,true) }
  end
end
