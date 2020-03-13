#include ApiHelper
module Api
  module V1
    module Comercio
      class ServiciosController < ComercioController

	before_action :cors, except: [:crea_colaborador]
	#, :cache_config


	def index

          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'
	  @comercio_servicios = ::Comercio::Servicio.high_low

	end

	#api para los comandos xhr llamados por los controles de precio, tipo de servicio. Estos controles pretenden filtrar el total de los servicios y dejar disponbibles solos los que quiera el usuarios. Están en la front de servicios.
	
	def filtrado
	  @todos = ::Comercio::Servicio.where(nil)
	  @filtro = params[:id]
	  case @filtro 
	  when "low-high-todos-servicios"
	    @comercio_servicios = @todos.low_high
          when "low-high-productos-servicios"
            @comercio_servicios = @productos.low_high.productos
          when "low-high-productos"
            @comercio_servicios = @productos.low_high.productos
	  when "low-high-instalaciones-servicios"
	    @comercio_servicios = @todos.low_high.instalacion
	  when "low-high-reparaciones-servicios"
	    @comercio_servicios = @todos.low_high.reparacion
	  when "low-high-ampliaciones-servicios"
	    @comercio_servicios = @todos.low_high.ampliacion
	  when "low-high-certificaciones-servicios"
	    @comercio_servicios = @todos.low_high.certificacion
	  when "low-high-mantenimientos-servicios"
	    @comercio_servicios = @todos.low_high.mantenimiento

	  when "high-low-todos-servicios"
	    @comercio_servicios = @todos.high_low
          when "high-low-productos-servicios"
            @comercio_servicios = @todos.high_low.productos
          when "high-low-productos"
            @comercio_servicios = @todos.high_low.productos
	  when "high-low-instalaciones-servicios"
	    @comercio_servicios = @todos.high_low.instalacion
	  when "high-low-reparaciones-servicios"
	    @comercio_servicios = @todos.high_low.reparacion
	  when "high-low-ampliaciones-servicios"
	    @comercio_servicios = @todos.high_low.ampliacion
	  when "high-low-certificaciones-servicios"
	    @comercio_servicios = @todos.high_low.certificacion
	  when "high-low-mantenimientos-servicios"
	    @comercio_servicios = @todos.high_low.mantenimiento

	  else
	  end

	  respond_to do |format|
	    format.json { } 
	  end
	end

	def show
          #xpires_in 3.minutes, :public => true
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          @comercio_servicio = ::Comercio::Servicio.find_by(id: params[:id])
          respond_to do |format|
            format.json {}
          end
	end

	#Carrusel de amp que muestra los servicios en una banda inferior llamada you my also want
	def carrusel
	  expires_in 13.minutes, :public => true

	  @comercio_servicios = ::Comercio::Servicio.all
	  @uno_solo = [1]

	  respond_to do |format|
	    if @comercio_servicios and @uno_solo
	      format.json {}
	    end
	  end
	end

	def creacion_exitosa_de_orden orden
          render json: orden, status: :ok
	end

	def creacion_fallida_de_orden orden
          render json: {"Error" => orden.errors }  , status: :unprocessable_entity 
	end

	#Agrega itemes a la orden del cliente actual.
	def addToCart

	  response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
	  response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'
          agrega_servicio_a_orden =::Comercio::AddToCart.new( ::Comercio::OrdenRepositorio, self )
          agrega_servicio_a_orden.crea current_user, params
=begin
	  respond_to do |format|
            servicio = ::Comercio::Servicio.find_by(:id => params[:id])
            if servicio.present?
	      if servicio.cantidad_disponible and servicio.cantidad_disponible > 0 and servicio.area and not servicio.area.empty?
                orden = ::Comercio::Orden.mas_reciente.find_or_create_by(:amp_cliente_id => params[:clientId])
                if orden.present?
		  if orden.pagado and orden.pagado?
		    orden = ::Comercio::Orden.create(:amp_cliente_id => params[:clientId])
		  end
                  orden.servicios << servicio
	          servicio.update_attributes(:cantidad_disponible => servicio.cantidad_disponible - 1)
                  format.json { render json: orden, status: :ok}
                else
                  format.json{ render json: {"Error" => "No se dispone de orden"} , status: :unprocessable_entity }
                end
              else
                format.json{ render json: {"Error" => "Servicio no disponible o fuera de área" }  , status: :unprocessable_entity }
              end
            else
             format.json{ render json: {"Error" => "Servicio no registrado"},status: :unprocessable_entity }
            end
	  end
=end
	end


	#Suma cada precio de items y obtiene un total neto
=begin
	def subtotalForCart
	  @orden = ::Comercio::Orden.mas_reciente.find_or_create_by(:amp_cliente_id => params[:clientId])
	  respond_to do |format|
	    #ormat.json{ render json: {:items => ["subtotal" => @orden.subtotal]}, status: :ok }
	    format.json {}
	  end
	end
=end
        #Suma cada precio de items y obtiene un total neto
        def totalForCart
         
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true


	  @orden = ::Comercio::Orden.mas_reciente.find_or_create_by(:amp_cliente_id => params[:clientId])

          respond_to do |format|
            format.json {}
          end
        end



        #Suma cada precio de items y obtiene un total neto
=begin
        def factiblidad
          @orden = ::Comercio::Orden.mas_reciente.find_or_create_by(:amp_cliente_id => params[:clientId])
          respond_to do |format|
            format.json {}
          end
        end
=end


	#Elimina un item y todos los iguales a este, desde el carro
	def dropFromCart
	  response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'


	  @orden = ::Comercio::Orden.mas_reciente.find_by(:amp_cliente_id => params[:clientId])

	  servicio = @orden.servicios.find_by(:id => params[:id])
	  linea = servicio.lineas.find_by(:orden => @orden.id)
	  linea.destroy! if linea
=begin  
	  @orden.servicios.each do |servicio| #si usa each se eliminan todos
	    if servicio.id.to_s == params[:id]
	      s.lineas.each{|l| l.destroy! if l.orden == @orden}
	    end
	  end
=end

          servicio = ::Comercio::Servicio.find_by(:id => params[:id])
          if servicio.cantidad_disponible
            servicio.cantidad_disponible = servicio.cantidad_disponible + 1
            servicio.save!
          end


	  @orden.touch
	  respond_to do |format|
	    format.json {  render json: @orden   ,  status: :ok  }
	  end
	end

	#Muestra lo ítemes de una orden; la que corresponda al cliente entregado como parámetros
	def cart
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          
          #expires_in 3.minutes, :public => true
	  @orden = ::Comercio::Orden.mas_reciente.find_by(:amp_cliente_id => params[:clientId])
          if @orden.pagado and @orden.pagado?
            @orden = ::Comercio::Orden.create(:amp_cliente_id => params[:clientId])
	  end

	  respond_to do |format|
	    if @orden
	      #puts params[:clientId]
	      @comercio_servicios = @orden.servicios.all
	      #puts "Hay #{@comercio_servicios.count} servicios"
	      #@comercio_servicios.each do |c|
	      #	puts c.nombre
	      #end
	      format.json {  }
	    else
	      format.json {  }
	    end
	  end
	end

        def solicitud_fallidamente_tomada e
        #  render json: {"Error" => e }  , status: :unprocessable_entity
        end

        def solicitud_exitosamente_tomada e
	 # render json: {"Error" => e }  , status: :unprocessable_entity
	end

        def error_enviando_notificacion_de_toma_de_solicitud e, suscripcion
	 # render json: {"Error" => e }  , status: :unprocessable_entity
	end


	def creacion_exitosa_de_colaborador colaborador
	  respond_to do |format|
	    format.json {  render json: colaborador.name.to_json ,  status: :ok  }
	  end
	end

	def creacion_fallida_de_colaborador orden
	  respond_to do |format|
	    format.json {  render json: orden.errors.to_json ,  status: :ok  }
	  end
	end

        def crea_colaborador
	  caso_de_uso = ::Comercio::CreaColaborador.new ::Comercio::OrdenRepositorio, self
	  caso_de_uso.crea_colaborador_y_redirecciona params
        end
      end
    end
  end
end
