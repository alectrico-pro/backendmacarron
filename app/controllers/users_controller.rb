class UsersController < ApplicationController
  include Linea
  skip_before_action :authenticate_request, only: :create



  # POST /users
  # POST /users.json
  def create

    name = ''
    'first_name last_name'.split.each do |a|
      linea.info a
      linea.info user_params[a.to_sym].inspect
      name += user_params[a].nil? ? '' : user_params[a]
    end

    name_json = { 'name' => name }

    comando = CreateUser.call( name_json, user_params[:email], user_params[:password], user_params[:password_confirmation])

    linea.info "Comando es #{comando.inspect}"

    if comando.result
      json = {:auth_token => token }
      render json: json, status: :ok 
      #redirect_to C.admin_login, notice: json
    else
      json = {"errores" => comando.errors.messages.map{|e| {:name =>e[0], :message => e[1].pop}}}
      render json: json, status: :not_found
      #redirect_to C.admin_registro, notice: json
    end
    

  end

  private
  def user_params
    params.require(:user).permit(:password, :first_name, :last_name, :email, :password_confirmation)
  end

end
