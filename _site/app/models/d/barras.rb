#genera el catalógo Legrand. Faltan las referencias y los precios.
  class D::Barras < D::ListaOrdenada
    include Linea

    def initialize

      super
     @repartidores=[]
     [100].each do |calibre|
            a= D::Repartidor.new("EN 60947-1",calibre, 'FENIX 100A/207',220,'Bipolar Riel DIN',4.5,20,2,40,"Riel DIN",500,4,[{5 => 5.5},{2=> 7.5}],"" )
            @repartidores << a
        end
     @repartidores.each{|e| add_nodo_ordenado_in e }

    @repartidores_bipolares_con_bornes=[]
     #bornes = {5=>{"alambre" =>[2,5], "cable" =>[1.5,10]}, 2=>{"alambre" => [10,25],"cable" => [6,16]}}
    #
     icc_peak  = [20  ,  18,   20,   20, 14.5, 27,  35,   27,   60]
     no_polos  = [ 2  ,   2,    4,     4,    4,  4,  1,     1,   1]
     no_modulos= [ 4  ,   8,    4,     6,    8,  10, 2,     2,   2]
     referencias=[4880,4882,4884,  4886, 4888, 4879,4871,4883,4873]
     bornes =    [  7,   15,   7,     9,   15,  15,  16,   13,  11]
                 [100,  125, 100,  125,   125, 160,  125, 160, 250 ].each_with_index do |calibre,index|
            a= D::Repartidor.new("IEC 947-1",calibre, 'LEGRAND' + calibre.to_s + "/"+ no_modulos[index].to_s, 220,'Repartidor Modular',0,icc_peak[index],no_polos[index],40,"Riel o Placa",500,no_modulos[index], bornes[index],referencias[index])
            @repartidores_bipolares_con_bornes << a
        end
     @repartidores_bipolares_con_bornes.each{|e| add_nodo_ordenado_in e }
   end


   def puts

     memoria.debug "Repartidores ingresados"
     @nodos.each do |p|
       memoria.debug "In #{p.In} #{p.modelo} "
     end

      #@nodos.get_nodos.each{|d| memoria.debug d.modelo}
      memoria.debug "Hay un total de: "
      memoria.debug @nodos.count
      memoria.debug "Protecciones ingresadas"
    end
  end


