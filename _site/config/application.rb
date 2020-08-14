require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.autoload_paths << Rails.root.join('lib')

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es_Cl

    config.time_zone = "Santiago"
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false


    config.middleware.insert_before 0, Rack::Cors do
      "https://github.com/ampproject/amphtml/blob/master/spec/amp-cors-requests.md"
      allow do

       origins URLS_PERMITIDAS
       
       #'http://162.158.225.145'
       #'http://192.168.137.190'
       #'https://192.168.137.190'
       #'https://help.alectrica.cl'
       #'https://bat.alectrica.cl'
       #'https://login.alectrica.cl'

    #----- API  ---- de frontend
        resource '/todos/*/items/*.json', :headers => :any, :methods => %(get), "max-age" => 0,:expose => ['AMP-Access-Control-Allow-Source-Origin']


    #------ API ---- de designer
        resource '/api/v1/electrico/presupuestos/*.json', :headers => :any, :methods => %(get), "max-age" => 0,:expose => ['AMP-Access-Control-Allow-Source-Origin']

        resource '/api/v1/electrico/circuitos/get/', :headers => :any, :methods => %(get,post,delete), "max-age" => 0,:expose => ['AMP-Access-Control-Allow-Source-Origin']

        resource '/api/v1/electrico/circuitos/cart/', :headers => :any, :methods => %(get,post,delete), "max-age" => 0,:expose => ['AMP-Access-Control-Allow-Source-Origin']



        resource '/api/v1/electrico/circuitos/*/dropFromCircuito.json', :header => :any, :methods => %(post), "max-age" => 0, :expose => ['AMP-Access-Control-Allow-Source-Origin']

        resource '/api/v1/electrico/circuitos/deleteElectrodomestico.json', :header => :any, :methods => %(post), "max-age" => 0, :expose => ['AMP-Access-Control-Allow-Source-Origin']


        resource '/api/v1/electrico/circuitos/syncFromRemote.json', :header => :any, :methods => %(post), "max-age" => 0, :expose => ['AMP-Access-Control-Allow-Source-Origin']

        resource '/api/v1/electrico/circuitos/addToCircuito.json', :header => :any, :methods => %(post), "max-age" => 0, :expose => ['AMP-Access-Control-Allow-Source-Origin']


        resource '/api/v1/electrico/circuitos/ocupacion.json', :header => :any, :methods => %(get), "max-age" => 0, :expose => ['AMP-Access-Control-Allow-Source-Origin']

        resource '/api/v1/electrico/circuitos/atencion.json', :header => :any, :methods => %(get), "max-age" => 0, :expose => ['AMP-Access-Control-Allow-Source-Origin']


      end 
    end
  end
end
