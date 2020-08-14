FactoryBot.define do
  factory :usuario, :class => Gestion::Usuario do
    user
    activo { true }
    nombre { "Usuario: #{Faker::Movies::StarWars.character }"}
    email  { "usuario_#{Faker::Internet.unique.free_email }"}
    fono   { "987654321" }
#    password { "123456" }
#    password_digest { "123456" }
#    password_digest {Faker::Internet.password( 9,  10, true,true) }
    after(:create) do |usuario, evaluator|
      #$logger.info "Usuario Factory creado #{usuario.nombre} - #{usuario.email}"
    end
  end
end
