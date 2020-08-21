class UsersController < ApplicationController
  include Linea
  skip_before_action :authenticate_request, only: :create



  # POST /users
  # POST /users.json
  def create

    linea.info "Los attributos de usuario son: #{user_params.inspect}"

    atributos = user_params.except( :__admin_source_origin, :first_name, :last_name )

    #Juntando first_name y last_name para formar name
    name = ''
    'first_name last_name'.split.each do |a|
      linea.info a
      linea.info user_params[a.to_sym].inspect
      name += user_params[a].nil? ? '' : user_params[a]
    end

    name_json = { 'name' => name }
    atributos = atributos.merge( name_json )


    linea.info "Los atributos para crear el usuario son: #{atributos.inspect}"

    user = User.new(atributos)

    if user.save
      #render json: {"resultado" => user.name }, status: :ok 
      redirect_to C.admin_login
    else
      render json: {"objeto" => "User.create en users_controller #{user.email}","verifyErrors" => user.errors.messages.map{|e| {:name =>e[0], :message => e[1].pop}}}, status: :not_found
      #redirect_to C.admin_registro
    end

  end

  private
  def user_params
    params.require(:user).permit(:password, :first_name, :last_name, :email, :password_confirmation)
  end

end
