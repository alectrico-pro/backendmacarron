module Estructura
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
  end
end
