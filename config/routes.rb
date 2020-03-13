Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :electrico do
	resources :circuitos,\
	  only: [:atencion,\
		 :ocupacion,\
		 :syncFromRemote,\
		 :addToCircuito,\
                 :addToInstalacion,\
		 :get,\
		 :cart,\
		 :dropFromCircuito,\
		 :deleteElectrodomestico] do
	   member do
	     post :dropFromCircuito
	   end
	   collection do
	     post :syncFromRemote
	     post :addToCircuito
             post :addToInstalacion
	     get  :get
	     get  :ocupacion
	     post :deleteElectrodomestico
	     get  :cart
	     get  :atencion
	  end
	end
      end
    end
  end

  resources :items, only: [:index] do
  end

  resources :todos do
    resources :items
  end

  resources :contactos, only: [:verify, :create] do
    collection do 
      post 'verify'
      post 'create'
    end
  end

  get 'get_items',      to: 'api/v1/electrico/circuitos#addToCircuito'
  get 'create_token',   to: 'authentication#create_token'
  get 'destroy_reader', to: 'authentication#destroy_reader'
  get 'authenticate',   to: 'authentication#authenticate'
  get 'sign_in',        to: 'authentication#login_reader'
#  get 'destroy_user',   to: 'authentication#destroy_user'
  #
# get 'sign_up',      to: 'authentication#create_user'
  get 'logout',       to: 'authentication#logout_user'

end
