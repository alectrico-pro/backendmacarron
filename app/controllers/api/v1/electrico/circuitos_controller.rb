module Api
  module V1

    module Electrico


      class ::TipoCircuito < Struct.new(:letras)

        def id
          1
        end

     end


     class ::TipoEquipo < Struct.new(:nombre)

        def id
          844
        end

        def img=(img)
          @img=img
        end
        
        def id=(id)
          @id=id
        end
 
        def img
          if @img
            @img
          else
            "/img/sintomas/fiebre_02.png"
          end
        end

        def p
          10
        end

      end


      class ::Carga < Struct.new(:id, :tipo_equipo,:circuito)

        
        def id
          844
        end

        def cantidad
          1
        end

      end


      class ::Circuito < Struct.new(:nombre, :tipo_circuito)

        attr_reader :cargas

        def errors
        end


        def agrega_carga carga
          unless @cargas
            @cargas = Array.new
          end
          @cargas << carga
          
        end

      end


      class ::Presupuesto < Struct.new(:usuario)

        def id
          1
        end

      end


      class ::Usuario < Struct.new(:nombre)
      end

        #Este es el feed de la lista de electrodomésticos en designer.alectrico.cl
	#Busca el presupuesto que esté asociado al dispositivo y muestra los electromésticos que lo componen
	#No está preocupado de averiguar si hay un usuario o no
	#Debiera cargar los electrodomésticos del usuario, para ello hay que avergiuar si hay algún usuario logado y luego averiguar si tiene algún prespuesto.
	#Entonces tendré dos presupuestos, el asociado al dispositivo y el pertenciente al usuario.
	#Deberé reemplazar el presupuesto asociado al dispositivo por el que trae el usuairo de cualquier otro dispositivo?
	#Se garantiza que cada usuario solo tenga un presupuesto por dispositivo, pero eso complica un poco, porque sí se permite que haya muchos presupuestos por usuario. Habrá que mostrar cuál es el presupuesto que quiere asociar al dispositivo antes de asignarlo al dispositiov
	#Será un menú de selector que aparecerá cuando un usuario se logge y no tenga un prespuesto en el dispositivo. Luego de efectuada la sección deberá desaparecer. No aparecerá más, porque desde ese momento habrá un prespuesto asociado al dispositivo, a no ser que se borre el dispositivo.
      class CircuitosController < ElectricoController

        skip_before_action :authenticate_request, only: [:addToCircuito]
        before_action :allow_credentials, only: [:addToCircuito]
 
        include ::Linea

	def atencion
          respond_to do |format|
            format.json
	  end
	end

        def get #Este es el get que estoy probando a la vez que lo diseño. Usa arquitectura hexagonal y single sign on. 
          expires_in 0.seconds, :public => false
          linea.info "En get"
          linea.info "Analizaré el macarron"

          #Se simulan el circuito para probar el nuevo desarrollo y generar la api.
          tipo_circuito = TipoCircuito.new( "I" )
          circuito      = ::Circuito.new( "Nombre", tipo_circuito  )
          tipo_equipo   = TipoEquipo.new( "Foco Embutido LED 20W" )
          id            = 1
          carga         = ::Carga.new( id, tipo_equipo, circuito )
          circuito.agrega_carga( carga )

          @circuito = JSON.parse(circuito.to_json)
          @cargas   = circuito.cargas

          @potencia_total_industrial = 0
          @potencia_total_domiciliaria = 0
          @potencia_bruta = 0
          @potencia_instalada = 0
          @fp_minimo = 0
          @is_total = 0
          @empalme_aereo_sugerido = nil
          @empalme_soterrado_sugerido = nil

          #GetCargas es un servicio hexagonal
        #  servicio = ::GetCargas.new( ::CargasTree , self )
         # servicio.get( circuito )

        end

	def get_original ##Este es el get original que ya ha funcionado con designer
	   expires_in 0.seconds, :public => false

          @presupuesto = ::Electrico::Presupuesto.find_by(:clientId => params[:clientId])
	  #if user_signed_in?
	  #  @presupuesto = current_user.usuario.presupuestos.unscope(:order).last
	  #end
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'

         #@circuito = @presupuesto.circuitos.find_by(:id => params[:id])
#	  @circuito = ::Electrico::Circuito.find_by(:id => params[:id])
	  @potencia_total_industrial = 0
	  @potencia_total_domiciliaria = 0
          @cargas = nil
          @potencia_bruta = 0
          @potencia_instalada = 0 
          @fp_minimo = 0
          @is_total = 0
          @empalme_aereo_sugerido = nil
	  @empalme_soterrado_sugerido = nil

          #respond_to do |format|
            if @presupuesto
	      #sanitizar los circuitos, 
	      @presupuesto.circuitos.each{|c| c.delete unless c.cargas.count > 0 }
	      factor_de_demanda = 0.35
	      @potencia_total_industrial = @presupuesto.cargas.sum(&:get_p)
	      @potencia_total_domiciliaria = @potencia_total_industrial > 3000 ? ((@potencia_total_industrial - 3000) * 0.35 + 3000) : @potencia_total_industrial
#              @cargas = @presupuesto.cargas.order('cargas.circuito_id')
	      @cargas = @presupuesto.cargas

              if @cargas.count >0
#		carga0 = @cargas.first.dup
		@tension           = 220
		#Obtención de la carga equivalente, un invento mío
#		carga0.reset(@tension)
	#	@carga_equivalente  = @cargas.each.reduce(carga0,:+) #/Ya no funciona iben, porque @presupuesto_cargas está sobrecargado
#		@potencia_bruta     = @carga_equivalente.get_p
		@potencia_bruta     = @presupuesto.cargas.sum(&:get_p)
		@potencia_instalada = (@potencia_bruta > 3000) ? ((@potencia_bruta - 3000) * factor_de_demanda + 3000)  : @potencia_bruta
#		@fp_minimo          = @carga_equivalente.get_fp
		@fp_minimo          = @presupuesto.cargas.min{|a,b| a.get_fp <=> b.get_fp}.get_fp
		@is_total           = @potencia_instalada/ (@tension * @fp_minimo )

	        @empalmes          = D::Empalmes.new
                @candidatos        = @empalmes.get_nodos.select{ |a| a.interruptor >= @is_total and a.medio == "Aéreo" and a.no_fases == "Monofásico" and a.cumple_potencia_nominal?(@potencia_instalada)}


		unless @candidatos.count > 0
                  @candidatos        = @empalmes.get_nodos.select{ |a| a.interruptor >= @is_total and a.medio == "Aéreo" and a.no_fases == "Trifásico" and a.cumple_potencia_nominal?(@potencia_instalada)}
		end
                @empalme_aereo_sugerido = @candidatos.first


                @candidatos        = @empalmes.get_nodos.select{ |a| a.interruptor >= @is_total and a.medio == "Subterráneo" and a.no_fases == "Monofásico" and a.cumple_potencia_nominal?(@potencia_instalada)}


                unless @candidatos.count > 0
                  @candidatos        = @empalmes.get_nodos.select{ |a| a.interruptor >= @is_total and a.medio == "Subterráneo" and a.no_fases == "Trifásico" and a.cumple_potencia_nominal?(@potencia_instalada)}
                end
                @empalme_soterrado_sugerido = @candidatos.first


              end
               
              #format.json {} #se usa json.builder en los subdirectorios de vistas
            else

	      #format.json {}
#	      format.json { render json: {:items => []}}
#              format.json { render json: {:Reporte => "No se encontró ningún prespuesto para clientId=#{params[:clientId]}"}}

#             format.json{ render json: "Error", status: :unprocessable_entity }
            end
          #end
	end

	def ocupacion
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'

          expires_in 0.seconds, :public => false
	  presupuesto = ::Electrico::Presupuesto.find_by(:clientId => params[:clientId])

          respond_to do |format|
            if presupuesto
              @circuitos = presupuesto.circuitos
              format.json {} #se usa json.builder en los subdirectorios de vistas
            else
              format.json { render json: {:items => []}}
            end
          end
	end


        def cart
           expires_in 0.seconds, :public => false

          #@presupuesto = ::Electrico::Presupuesto.find_by(:clientId => params[:clientId])
          if user_signed_in?
            @presupuesto = current_user.usuario.presupuestos.unscope(:order).last
          end
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'

         #@circuito = @presupuesto.circuitos.find_by(:id => params[:id])

#         @circuito = ::Electrico::Circuito.find_by(:id => params[:id])
          respond_to do |format|
            if @presupuesto
              @cargas = @presupuesto.cargas
              format.json {} #se usa json.builder en los subdirectorios de vistas
            else
              format.json { render json: {:items => []}}
#              format.json { render json: {:Reporte => "No se encontró ningún prespuesto para clientId=#{params[:clientId]}"}}

#             format.json{ render json: "Error", status: :unprocessable_entity }
            end
          end
        end

        def deleteElectrodomestico
          expires_in 0.seconds, :public => false

          @carga = ::Electrico::Carga.find_by(:id => params[:id])
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'
          circuito = @carga.circuito

          respond_to do |format|
            if @carga.delete
              circuito.update_attributes(:corriente_servicio => circuito.cargas.sum(&:get_i))
              @cargas = @carga.circuito.cargas
              format.json {}
            else
              format.json { render json: {:error =>  @carga.errors[:base]}, status: :unprocessable_entity }
            end
          end
        end

	def dropFromCircuito
	  expires_in 0.seconds, :public => false

	  @carga = ::Electrico::Carga.find_by(:id => params[:id])
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'

	  circuito = @carga.circuito

	  respond_to do |format|
	    if @carga.delete
              circuito.update_attributes(:corriente_servicio => circuito.cargas.sum(&:get_i))
	      @cargas = @carga.circuito.cargas
	      format.json {}
	    else	
	      format.json { render json: {:error =>  @carga.errors[:base]}, status: :unprocessable_entity }
	    end     		  
	  end
	end

	def syncFromRemote
          expires_in 0.seconds, :public => false

          @presupuesto_local = ::Electrico::Presupuesto.find_by(:clientId => params[:clientId]) if params[:clientId]

          if user_signed_in?
	    #Si inicia sesión un usuario que ya tenga presupuesto. Entonces, su presupuesto pasa a ser el presupuesto local. A menos que su presupuesto ya sea el presupuesto local. En ese caso no se hace nada
            @presupuesto_user = current_user.usuario.presupuestos.unscope(:order).last
	    if @presupuesto_user.clientId != params[:clientId]
	      @presupuesto_user.clientId = params[:clientId]
	      @presupuesto_user.save!
	      @presupuesto_local.destroy if @presupuesto_local
	    else

	    end

#	    @presupuesto.update_attributes(:clientId => nil) if @presupuesto
          end

          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'

         #@circuito = @presupuesto.circuitos.find_by(:id => params[:id])

#         @circuito = ::Electrico::Circuito.find_by(:id => params[:id])
          respond_to do |format|
            if @presupuesto
              @cargas = @presupuesto.cargas
              format.json {} #se usa json.builder en los subdirectorios de vistas
            else
              format.json { render json: {:items => []}}
#              format.json { render json: {:Reporte => "No se encontró ningún prespuesto para clientId=#{params[:clientId]}"}}

#             format.json{ render json: "Error", status: :unprocessable_entity }
            end
          end
	end

        def addToCircuito

          linea.info "En AddToCircuito"

          tipo_equipo   = TipoEquipo.new("Foco Embutido LED 20W")
          tipo_circuito = TipoCircuito.new("I")
          circuito      = ::Circuito.new("Nombre", tipo_circuito )
          carga         = Carga.new(tipo_equipo, circuito)
          circuito.agrega_carga(carga)
          cargas        = circuito.cargas
          servicio      = ::AgregaCarga.new( :CargasTree , self, params )
          servicio.agrega_carga
        end

        def addToInstalacion

          linea.info "En AddToInstalacion"

	  tipo_equipo   = TipoEquipo.new("Foco Embutido LED 20W")
	  tipo_circuito = TipoCircuito.new("I")
          circuito      = ::Circuito.new("Nombre", tipo_circuito )
          carga         = Carga.new(tipo_equipo, circuito)
          circuito.agrega_carga(carga)
	  cargas        = circuito.cargas
          token         = params[:auth_token]
          decoded_token = JsonWebToken.decode( token )
          linea.info "Token decodificado #{decoded_token}"

          circuito_hash = decoded_token["circuito"]
          largo = 10
          max_spur = 10
          grupo    = 'A'
          tipo_circuito = circuito_hash['tipo_circuito']

          circuito = Mock::Circuito.new( largo, max_spur, grupo, tipo_circuito)
          servicio = ::AgregaCargaAInstalacion.new( circuito, ::CargasTree , self, params )
          servicio.agrega_carga

	end

        def addToCircuito_original
          presupuesto = ::Electrico::Presupuesto.find_by(:clientId => params[:clientId]) if params[:clientId]


	  if params[:clientId] and presupuesto and user_signed_in? and current_user.usuario
	    presupuesto.update_attributes(:usuario => current_user.usuario)
	  end

	  desistir = false
          if true  
	    #esistir = true
     
	    tipo_equipo =  ::Electrico::TipoEquipo.find_by(:id => params[:carga_id])
	    #tipo_equipo.img = params[:img]
	    #tipo_equipo.save!

	    tipo_circuito = ::Electrico::TipoCircuito.find_by(:letras => params[:circuito])

	    if tipo_circuito
	      @presupuesto = ::Electrico::Presupuesto.find_or_create_by(:clientId => params[:clientId]) do |p|
		p.efimero = true
	      end

	      if @presupuesto.save(:context => :designer)
		@circuito  = @presupuesto.circuitos.find_or_create_by(:tipo_circuito => tipo_circuito)  do |c|
		  c.largo = 10
		  c.grupo = "A"
		end

		cantidad = params[:quantity].to_i
		for i in 1..cantidad
		  @carga = @circuito.cargas.create do |carga|
		    carga.tipo_equipo = tipo_equipo
		    cantidad          = 1
		  end
		end
                
		@circuito.corriente_servicio = @circuito.cargas.sum(&:get_i)
		
  #	      if @circuito.save
  #		@presupuesto.circuitos << @circuito unless @presupuesto.circuitos.any?
  #	      end
	      end
	    end


	         #Estrategia recomendada para igualar el identificador de usuario que usa google analytics y el que usa google para las páginas amp.
	         #Se toma el id que viene en el requeste en el parámetros ref_id, y se setea la cookie uid que se usó antes para extraer el parámetro clienteId, por lo tanto, se obtiene que params[:clientId] tendrá el mismo valor que params[:ref_id] = amp_access o algo asaccess o algo así #  @circuitos = ::Electrico::Circuito.all
	    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
	    response.headers['Access-Control-Allow-Credentials'] = true
	    response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'
	  end

          respond_to do |format|

	    if desistir
              format.json { render json: {:error => "Debe hacer login para agregar más electrodomésticos."}, status: :unprocessable_entity}
            else
	      unless tipo_circuito
		format.json { render json: {:error => "No existe el tipo de circuito #{params[:circuito]}"}, status: :unprocessable_entity}
	      else

		if @presupuesto.save(:context => :designer)
		  #format.json { render json: @presupuesto, status: :ok}
		  @cargas = @circuito.cargas

		  if @circuito.save
    #                format.json { render json: @circuito, status: :ok}
		    if @carga.save
		      @cargas = @circuito.cargas
		      #format.json { render json: @circuito.cargas, status: :ok}
		      format.json {} #se usa json.builder en los subdirectorios de vistas
		    else
    #	  format.json { render json: {:verifyErrors => [{:name => :email, :message => "Este dispositivo no usa #{params_verify[:email]}"  }] }, status: :not_found}
		     #format.json {}
		      format.json { render json: {:error =>  @carga.errors[:base]}, status: :unprocessable_entity }
		    end
		  else
		    format.json {}
    #                format.json { render status: :unprocessable_entity }
		  end
		else
		  format.json { render json: {:error =>  @presupuesto.errors}, status: :unprocessable_entity }
		end
	      end
	    end
          end
        end

        def carga_exitosamente_agregada servicio
          @circuito = servicio.circuito
          @cargas    = @circuito.cargas.each
          linea.info "Carga exitosamente Agregada"
        end
      
        def carga_fallidamente_agregada servicio
          linea.warn "Carga no pudo ser Agregada"
        end
     
        def carga_exitosamente_eliminada
          linea.info "Carga exitosamente Eliminada"
        end
     
        def carga_fallidamente_eliminada
          linea.warn "Carga no pudo ser Eliminada"
        end

        def get_cargas cargas, circuito
          @cargas = cargas
          @potencia_total_industrial = 0
          @potencia_total_domiciliaria = 0
          @potencia_bruta = 0
          @potencia_instalada = 0
          @fp_minimo = 0
          @is_total = 0
          @empalme_aereo_sugerido = nil
          @empalme_soterrado_sugerido = nil
          linea.info "Mostrando en get_cargas"
        end

  private
       #Estrategia recomendada para igualar el identificador de usuario que usa google analytics y el que usa google para las páginas amp.
       #Se toma el id que viene en el requeste en el parámetros ref_id, y se setea la cookie uid que se usó antes para extraer el parámetro clienteId, por lo tanto, se obtiene que params[:clientId] tendrá el mismo valor que params[:ref_id] = amp_cid
       def cid

          ref_id    = params[:ref_id].gsub!("'",'') if params[:ref_id]
          client_id = params[:clientId] if params[:clientId]

	  if ref_id
             cid = ref_id
	     cookies[:uid] = { value: ref_id, domain: '.alectrico.cl'} 
          end

          if client_id
             cid = client_id
	  end
    
          return cid
        end
      end
    end
  end
end
