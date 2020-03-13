module Api
  module V1
    class NotificacionesController < V1Controller

      before_action :set_notificacion, only: :destroy

      #Es llamado desde javascript en diferenes casos de uso. 
      #El primero es cuando del lado del cliente haya un usuario autorizado
      #El segundo es cuando del lado del cliente esté un cliente no inscrito
      def destroy

        if current_user and current_user.id and current_user.id == @notificacion.user_id
	  @notificacion.destroy
	elsif not current_user
	  @notificacion.destroy
        else
	  #  @notificacion.destroy
	end
       
	respond_to do |format|
	  if current_user and current_user.id and current_user.id == @notificacion.user_id
            format.json {render :json =>{"data" => {"success" => 1}}, :status => :ok }
	  elsif not current_user
            format.json {render :json =>{"data" => {"success" => 1}}, :status => :ok }
	  else
            format.json {head :unauthorized}
	  end
	end
      end


      def create
#user_id = current_user.id
	if current_user and current_user.id
	  #notificacion = ::Electrico::Notificacion.find_or_initialize_by(:user_id => current_user.id)
	  notificacion = ::Electrico::Notificacion.find_or_create_by(:auth => notificacion_params[:keys][:auth], :user_id => current_user.id) do |notificacion|
             notificacion.endpoint = notificacion_params[:endpoint]
	     notificacion.p256dh   = notificacion_params[:keys][:p256dh]
#     notificacion.auth     = notificacion_params[:keys][:auth]
	     notificacion.vapid_public  = $vapid_public
	     notificacion.vapid_private = $vapid_private
	     notificacion.user_id  = current_user.id
	  end

        else
             notificacion = ::Electrico::Notificacion.new         
             notificacion.endpoint = notificacion_params[:endpoint]
             notificacion.p256dh   = notificacion_params[:keys][:p256dh]
             notificacion.auth     = notificacion_params[:keys][:auth]
             notificacion.vapid_public  = $vapid_public
             notificacion.vapid_private = $vapid_private
	     notificacion.save
	end

	respond_to do |format|

	  if notificacion.save
	    format.json {
	      render json: { data: {success: 1 } }, :status => :ok 
	    } 
          else
            format.json {
               render json: { data: {errores: notificacion.errors.to_json } }, :status => :not_found #Esperado por javascript
	    }
	  end
	end
     end

private

    def set_notificacion
      @notificacion = ::Electrico::Notificacion.find_by(:auth => params[:keys][:auth])
    end

    def notificacion_params
      params.require(:notificacion).permit(:api_key,:expirationTime, :endpoint,:expirationTime, :keys => [:p256dh, :auth])
    end

    private
    def cors

      #Solo chequea que el origen esté dentro de los permitidos

      @origen = request.headers['Origin']

      if @origen
        case @origen
          when
            "https://iframe.alectrico.cl"
          when
            "https://cdn.ampproject.org"
          when
            "http://192.168.137.190:3000"
          when
            "https://192.168.137.190:3000"
          when
            "http://staging.alectrico.cl"
          when
            "https://staging.alectrico.cl"
          when
            "https://staging-alectrico-cl.cdn.ampproject.org"


          when
            "https://shop.alectrico.cl"
          when
            "https://shop-alectrico-cl.cdn.ampproject.org"
          when
            "https://shop-alectrico-cl.amp.cloudflare.com"

          when
            "https://shop-staging.alectrico.cl"
          when
            "https://shop-staging-alectrico-cl.cdn.ampproject.org"
          when
            "https://shop-staging-alectrico-cl.smp.cloudflare.com"

          when
            "https://iframe.alectrico.cl"
          when
            "https://iframe-alectrico-cl.cdn.ampproject.org"
          when
            "https://iframe-alectrico-cl.amp.cloudflare.com"

          when
            "https://iframe-staging.alectrico.cl"
          when
            "https://iframe-staging-alectrico-cl.cdn.ampproject.org"
          when
            "https://iframe-staging-alectrico-cl.smp.cloudflare.com"

          when
            "https://servicios.alectrico.cl"
          when
            "https://servicios-alectrico-cl.cdn.ampproject.org"
          when
            "https://servicios-alectrico-cl.smp.cloudflare.com"


          when
            "https://designer.alectrico.cl"
          when
            "https://designer-alectrico-cl.cdn.ampproject.org"
          when
            "https://designer-alectrico-cl.smp.cloudflare.com"


          when
            "https://stories.alectrico.cl"
          when
            "https://stories-alectrico-cl.cdn.ampproject.org"
          when
            "https://stories-alectrico-cl.smp.cloudflare.com"

          when
            "http://www.alectrico.cl"
          when
            "https://www.alectrico.cl"
          when
            "https://www-alectrico-cl.amp.cloudflare.com"
          when
            "https://www-alectrico-cl.cdn.ampproject.org"


          else
            render json: {"Origen No Autorizado" => params[:name]}, status: 401
          end

        else
          if request.headers['AMP-Same-Origin']
            #Todo bien, puede proseguir
          else
            render json: {"No se han especificado Headers acerca del origen" => @origen}, status: 401
          end
        end
      end
    end
  end
end
