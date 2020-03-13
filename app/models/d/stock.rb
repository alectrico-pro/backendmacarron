#encoding: UTF-8
#genera el catalógo Legrand. Faltan las referencias y los precios.
  class D::Stock < D::ListaOrdenada
    include Linea 
    def nombre
      "stock"
    end

    def initialize
      #DX3(In0.5-125) PdC(10,16,25,36,50kA) IED 60947-2 Modular (MCB) Modulares
      #DPX3(16-250) PdC( 16 a 70kA) Caja moldeada
      #DPX,  Caja Moldeada
      #DRX,  Caja Moldeada
      #DMX3 CAJA Abierta
      super

      pdc_6 =PdC.new(6000,10,100)
      pdc_10=PdC.new(10000,16,100)

      pdc_16=PdC.new(nil,16,100)
      pdc_20=PdC.new(nil,20,100)
      pdc_25=PdC.new(nil,25,100)
      pdc_36=PdC.new(nil,36,100)
      pdc_50=PdC.new(nil,50,100)
      pdc_70=PdC.new(nil,70,75)
      pdc_100=PdC.new(nil,100,100)
      pdc_100_50=PdC.new(nil,100,50)



      r = (407425..407448).to_a
      r.delete(407431)
      ref_unipolar_b           = {'B' => r}

      p = [35210,
	   27380,
	   27380,
	   27380,
	   13720,
	   13720,
	   13720,
	   13720,
	   13720,
	   13720,
	   13720,
	   16730,
	   16730]

      p_unipolar_b           = {'B' => p}

     
      r = (407662..407676).to_a
      r.delete(407667)
      r.delete(407669)
      ref_unipolar_c           = {'C' => r}
     
      p = [15560,
           15560,
	   15560,
	   15560,
	   7720,
	   7560,
	   7560,
	   7720,
	   7720,
	   7720,
	   7720,
	   17350,
	   17350
           ]
           
      p_unipolar_c           = {'C' => p}




      r = (407963..407977).to_a
      r.delete(407968)
      r.delete(407970)
      ref_unipolar_d           = {'D' => r}

      ref_unipolar_d.merge!( ref_unipolar_b)
      ref_unipolar_d.merge!( ref_unipolar_c)
      ref_unipolar = { 6 => ref_unipolar_d }


      p = [35220,
	   27380,
	   27380,
	   27380,
	   13950,
	   13950,
	   13950,
	   13950,
	   13950,
	   13950,
	   13950,
	   13950,
	   16730,
	   16730
           ]
      p_unipolar_d         = {'D' => p}

      p_unipolar_d.merge!( p_unipolar_b )
      p_unipolar_d.merge!( p_unipolar_c )
      p_unipolar = {6 => p_unipolar_d}
#------------

      r =  (407468..407479).to_a
      r.delete(407474)
      ref_unipolar_mas_neutro_b = {'B' => r}

      r=  (407734..407746).to_a
      r.delete(407739)
      r.delete(407741)
      ref_unipolar_mas_neutro_c = {'C' => r}
      ref_unipolar_mas_neutro_d = {'D' => []}


      ref_unipolar_mas_neutro_d.merge!( ref_unipolar_mas_neutro_b )
      ref_unipolar_mas_neutro_d.merge!( ref_unipolar_mas_neutro_c )


      ref_unipolar_mas_neutro = { 6 => ref_unipolar_mas_neutro_d }
#---------------      
      r = (407502..407515).to_a
      r.delete(407508)
      ref_bipolar_b          = {'B' => r}
      
      r = (407792..407806).to_a
      r.delete(407797)
      r.delete(407799)
      ref_bipolar_c         =  {'C' => r}

      r = (408023..408037).to_a
      r.delete(408028)
      r.delete(408030)
      ref_bipolar_d         =  {'D' => r}
      
      ref_bipolar_d.merge!( ref_bipolar_b)
      ref_bipolar_d.merge!( ref_bipolar_c)
      ref_bipolar = { 6 => ref_bipolar_d }


#--------------
      r = (407554..407567).to_a
      r.delete(407560)
      ref_tripolar_b           =  {'B' => r}
    
      
      p            = [92300,
		      79040,
		      79040,
		      79040,
		      52470,
		      52470,
		      52470,
		      52470,
		      52470,
		      52470,
		      52470,
		      59450,
		      59450]
	              
      p_tripolar_b             = {'B' => p}

      r = (407851..407865).to_a
      r.delete(407856)
      r.delete(407858)
      ref_tripolar_c           =  {'C' => r}

      p =  [66120,
	    66120,
	    66120,
	    66120,
	    41660,
	    34860,
	    34860,
	    34860,
	    34860,
	    34860,
	    34860,
	    59240,
            59240
           ]

       p_tripolar_c              = {'C' => p}

      r = (408081..408095).to_a
      r.delete(408086)
      r.delete(408088)
      ref_tripolar_d           = {'D' => r}


      p = [
	   92290,
	   79030,
	   79030,
	   79030,
	   59710,
	   59710,
	   59710,
	   59710,
	   59710,
	   59710,
           59710,
	   67810,
	   68160
        ]

      p_tripolar_d              = {'D' => p}

      ref_tripolar_d.merge!( ref_tripolar_c)
      ref_tripolar_d.merge!( ref_tripolar_b)
      ref_tripolar = { 6 => ref_tripolar_d }

      p_tripolar_d.merge!(p_tripolar_c)
      p_tripolar_d.merge!(p_tripolar_b)

      p_tripolar = { 6 => p_tripolar_d }

#--------------
      r = (407617..407630).to_a
      r.delete(407623)
      ref_tetrapolar_b         =  {'B' => r}

      r= (407920..407934).to_a
      r.delete(407925)
      r.delete(407927)
      ref_tetrapolar_c       =   {'C' => r}


      r = (408143..408153).to_a
      r.unshift('')
      r.unshift('')
      r.unshift('')
      r.unshift('')
      r.delete(408144)
      r.delete(408146)
      ref_tetrapolar_d       =   {'D' => r}


      ref_tetrapolar_d.merge!( ref_tetrapolar_b)
      ref_tetrapolar_d.merge!( ref_tetrapolar_c)
      ref_tetrapolar = { 6 => ref_tetrapolar_d}


      #referencias =  {"1" => ref_unipolar}, {"1+N" => ref_unipolar_mas_neutro}, {"2" => ref_bipolar},{"3" => ref_tripolar}, {"4" => ref_tetrapolar}

      
      ['B','C','D'].each do |curva|
       referencias = []
       i=0
       [1,2,3,4, 6,10,16,20,25,32,40,50,63].each do |calibre|

	if ref_tetrapolar[6][curva]
	  referencias = 
	    {  1 => ref_unipolar[6][curva][i],
	     1.5 => ref_unipolar_mas_neutro[6][curva][i],
	       2 => ref_bipolar[6][curva][i],
	       3 => ref_tripolar[6][curva][i],
	       4 => ref_tetrapolar[6][curva][i]
	    }
          if p_unipolar and p_unipolar[6][curva]
             precios = { 1 => p_unipolar[6][curva][i],
	                 3 => p_tripolar[6][curva][i]
	     }
	  end
	end
         a=   AutomaticoCurva.new(pdc_6, calibre, 'DX3 '+curva+calibre.to_s , curva,1,"Modular (MCB)")
         a.set_industrial
	 #a.referencia = referencias
         add_nodo_ordenado a

         b = AutomaticoCurva.new(pdc_6, calibre, 'DX3 '+curva+calibre.to_s , curva,1,"Modular (MCB)")
         b.set_domiciliario
	 b.referencia = referencias
	 b.precio  = precios
         add_nodo_ordenado b
	 i += 1
       end
      end



   ['B','C'].each do |curva|
       [1,2,3,4, 6,10,16,20,25,32,40,50,63].each do |calibre|

         a=   AutomaticoCurva.new(pdc_10, calibre, 'DX3 '+curva+calibre.to_s , curva,1,"Modular (MCB)")
         a.set_industrial
         add_nodo_ordenado a

         b=   AutomaticoCurva.new(pdc_10, calibre, 'DX3 '+curva+calibre.to_s , curva,1,"Modular (MCB)")
         b.set_domiciliario
         add_nodo_ordenado b
       end
      end


      ['C','D'].each do |curva|
       [63,80,100,125].each do |calibre|
         a=   AutomaticoCurva.new(pdc_10, calibre, 'DX3 '+curva+calibre.to_s , curva,1.5,"Modular (MCB)")
         a.set_industrial
         add_nodo_ordenado a
         b=   AutomaticoCurva.new(pdc_10, calibre, 'DX3 '+curva+calibre.to_s , curva,1.5,"Modular (MCB)")
         b.set_domiciliario
         add_nodo_ordenado b
       end
      end


      ['C'].each do |curva|
        [2,3,4,6,10,20,25,32].each do |calibre|
           a=   AutomaticoCurva.new(pdc_25, calibre, 'DX3 '+curva+calibre.to_s , curva,1,"Modular (MCB)")
           a.set_industrial
           add_nodo_ordenado a
         end
      end


     ['D'].each do |curva|
        [2,3,4,6,10,20].each do |calibre|
         a= AutomaticoCurva.new(pdc_25, calibre, 'DX3 '+curva+calibre.to_s , curva,1,"Modular (MCB)")
         a.set_industrial
         add_nodo_ordenado a
       end
      end


     ['C'].each do |curva|
        [32,40,50,63,80,100,125].each do |calibre|


          a=   AutomaticoCurva.new(pdc_25, calibre, 'DX3 '+curva+calibre.to_s , curva,1.5,"Modular (MCB)")
          a.set_industrial
          add_nodo_ordenado a
        end
      end



     ['D'].each do |curva|
       [20,25,32,40,50,63,80,100,125].each do |calibre|
         a=   AutomaticoCurva.new(pdc_25, calibre, 'DX3 '+curva+calibre.to_s , curva,1.5,"Modular (MCB)")
         a.set_industrial
         add_nodo_ordenado a
       end
      end


      ['D'].each do |curva|
        [20,25,32,40,50,63,80,100,125].each do |calibre|
           a=   AutomaticoCurva.new(pdc_25, calibre, 'DX3 '+curva+calibre.to_s , curva,1.5,"Modular (MCB)")
           a.set_industrial
           add_nodo_ordenado a
        end
      end

      ['C'].each do |curva|
        [6,10,16,20,25,32,40,50,63,80].each do |calibre|
          a= AutomaticoCurva.new(pdc_36, calibre, 'DX3 '+curva+calibre.to_s , curva,1.5,"Modular (MCB)")
          a.set_industrial
          add_nodo_ordenado a
        end
      end


      ['C','D'].each do |curva|
        [6,10,16,20,25,32,40,50,63].each do |calibre|
         a=   AutomaticoCurva.new(pdc_50, calibre, 'DX3 '+curva+calibre.to_s , curva,1.5,"Modular (MCB)")
         a.set_industrial
         add_nodo_ordenado a
       end
      end

      @caja_moldeada=[]
     [pdc_16,pdc_25,pdc_36,pdc_50].each do |pdc|
     [16,20,25,32,40,50,63,80,100,125,160].each do |calibre|

            a= AutomaticoRegulable.new(pdc, calibre, 'DPX3 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end

      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Perfil o Placa"}

      @caja_moldeada.each{|e| add_nodo_ordenado e }
      @caja_moldeada = []

    [pdc_20].each do |pdc|
    [15,20,25,30,40,50,63,80,100,125].each do |calibre|
            a= AutomaticoFijo.new(pdc, calibre, 'DRX 125 ' + calibre.to_s,"Caja Moldeada", 125 )
            @caja_moldeada << a
        end
     end


      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.tres_polos = true;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Perfil o Placa"
                          }

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []

    [pdc_36].each do |pdc|
    [15,20,25,30,40,50,60,63,75,80,100,125].each do |calibre|
            a= AutomaticoFijo.new(pdc, calibre, 'DRX 125 In= ' + calibre.to_s,"Caja Moldeada",125 )
            @caja_moldeada << a
        end
     end


      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.tres_polos = true;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Perfil o Placa"
                          }

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []



    [pdc_36].each do |pdc|
    [15,20,25,30,40,50,60,63,75,80,100,125].each do |calibre|
            a= AutomaticoFijo.new(pdc, calibre, 'DRX 125 In= ' + calibre.to_s,"Caja Moldeada",125 )
            @caja_moldeada << a
        end
     end


      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Perfil o Placa"
                          }

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []



    [pdc_25,pdc_36].each do |pdc|
    [125, 160, 200, 225, 250].each do |calibre|
            a= AutomaticoFijo.new(pdc, calibre, 'DRX 250 In= ' + calibre.to_s,"Caja Moldeada",250 )
            @caja_moldeada << a
        end
     end


      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.tres_polos = true;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Perfil o Placa"
                          }

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []


    [pdc_36,pdc_50].each do |pdc|
    [320, 400, 500, 630].each do |calibre|
            a= AutomaticoFijo.new(pdc, calibre, 'DRX 630 In= ' + calibre.to_s,"Caja Moldeada",630 )
            @caja_moldeada << a
        end
     end


      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.tres_polos = true;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Perfil o Placa"
                          }

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []




    [pdc_25,pdc_36,pdc_50,pdc_70].each do |pdc|
    [100,125,160,200,250].each do |calibre|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX3 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end


      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Perfil o Placa"
                          }

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []



     [40,50,63,80,100,125,160,200,250].each do |calibre|
        [pdc_25,pdc_36,pdc_50,pdc_70].each do |pdc|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX3 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end



      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Electrónico";
                          a.montaje   ="Perfil o Placa"}

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []


    [pdc_36,pdc_70,pdc_100_50].each do |pdc|
    [320,630].each do |calibre|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX 630 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end


      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="en Placa"}

      c=@caja_moldeada.select{|a| a.In=16 or a.In=25 }
                      .map   {|a| a.In=400}


            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []


  [pdc_36,pdc_70,pdc_100_50].each do |pdc|
  [250,320,630].each do |calibre|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX 630 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end




      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Electrónico";
                          a.montaje   ="en Placa"}


            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []


 [pdc_36,pdc_70,pdc_100].each do |pdc|
  [800,1250].each do |calibre|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX 1250/1600 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end




     @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="en Placa"}

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []


 [pdc_50,pdc_70].each do |pdc|
  [800,1250,1600].each do |calibre|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX 1250/1600 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end



      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Electrónico";
                          a.montaje   ="en Placa"}

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []


  referencias= [420000,420040,420080,420020]
  i=0
  [pdc_16,pdc_25,pdc_36,pdc_50].each do |pdc|
      base=referencias[i]
      i+=1

      [16,25,40,63,80,100,125,160].each do |calibre|

            a= AutomaticoRegulable.new(pdc, calibre, 'DPX3 160 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            a.referencia = base
            base+=1
            a.voltaje = 400

            @caja_moldeada << a
        end
     end
      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Fijo o Enchufable";
                          a.minima_regulacion_del_termico_per_design=0.8;
                          a.n_magnetico_fijo = 10    }

      @caja_moldeada.select{|a| a.In==16 or a.In==25 }.map{|a| a.Im=400}


            @caja_moldeada.each{|e| add_nodo_ordenado e }

                  @caja_moldeada = []


 [pdc_16,pdc_25,pdc_36,pdc_50,pdc_70].each do |pdc|
 [100,160,200,250].each do |calibre|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX3 250 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end





      @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio = "Magneto Térmico";
                          a.montaje   ="Fijo o Enchufable";
                          a.tres_polos= true;
                          a.cuatro_polos= true;
                          a.medidas=true;
                          a.proteccion_tierra=true}

            @caja_moldeada.each{|e| add_nodo_ordenado e }
                  @caja_moldeada = []


 [pdc_25,pdc_36,pdc_50,pdc_70].each do |pdc|
 [40,100,160,250].each do |calibre|
            a= AutomaticoRegulable.new(pdc, calibre, 'DPX3 250 In= ' + calibre.to_s,0.4,"Caja Moldeada" )
            @caja_moldeada << a
        end
     end




     @caja_moldeada.each{|a|
                          a.set_industrial;
                          a.principio= "Electrónico";
                          a.montaje="Fijo o Enchufable";
                          a.tres_polos= true;
                          a.cuatro_polos= true;
                          a.medidas=true;
                          a.proteccion_tierra=true}


      @caja_moldeada.each{|e| add_nodo_ordenado e }
      @caja_moldeada = []

    end




 def puts

     memoria.debug "Protecciones ingresadas"
     @nodos.each do |p|

       memoria.debug "PdC #{p.pdc} In #{p.In} #{p.modelo} #{p.Im} #{p.referencia}"
     end

      #@nodos.get_nodos.each{|d| memoria.debug d.modelo}
      memoria.debug "Hay un total de: "
      memoria.debug @nodos.count
      memoria.debug "Protecciones ingresadas"

      dpx3=@nodos.select{|n| n.modelo.include?('DPX3 160')}
      dpx3.each do |d|
        memoria.debug "#{d.modelo} #{d.principio} #{d.In}#{d.referencia}  #{d.montaje} Im_minima #{d.Im_minima} Im_maxima #{d.Im_maxima} Uo #{d.voltaje} regulacion #{d.minima_regulacion_del_termico_per_design} #{d.standard} Im #{d.Im}"
      end
    end
  end


