module Api
  module V1
    module Electrico
      class PresupuestosController < ElectricoController
        before_action :cors, :cache_config

        def show
	  @presupuesto = ::Electrico::Presupuesto.find_by(:clientId => params[:clientId]) 
          response.headers['Access-Control-Allow-Origin'] = request.headers['Origin']
          response.headers['Access-Control-Allow-Credentials'] = true
          response.headers['Access-Control-Expose-Headers'] = 'AMP-Access-Control-Allow-Source-Origin'
          respond_to do |format|
            if @presupuesto
	      format.json {} #se usa json.builder en los subdirectorios de vistas
	    else
              format.json{ render json: "Error", status: :unprocessable_entity }
            end
          end
        end

        private

  
	def cors
	  @origen = params[:__amp_source_origin]

	  if request.headers['Origin']
	    case @origen
	    when
	      "https://designer.alectrico.cl"
	    else
	      render json: {"Origen No Autorizado" => params[:name]}, status: 401

	    end
	    response.headers['AMP-Access-Control-Allow-Source-Origin'] = @origen

	  else
	    if request.headers['AMP-Same-Origin']
	      response.headers['AMP-Access-Control-Allow-Source-Origin'] = @origen

	      #Todo bien, puede proseguir
	    else
	      render json: {"No se han especificado Headers acerca del origen" => params[:name]}, status: 401
	    end
	  end
	end
      end
    end
  end
end
