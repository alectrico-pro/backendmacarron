#Esta es una implementación genérica de una lista, basada en nodos 
module D
class D::Lista 

  include Linea

  def initialize
    @nodos=[]
  end

  def set_id(a_id)
    @id = a_id
  end

  def get_id
    @id
  end

  def get_nodo(index)
    a_nodo = @nodos[index]
  end

  def get_last_nodo
    a_nodo = @nodos[@nodos.size-1]
  end

  def get_nodos
    new_nodos = @nodos.dup
  end

  def number_of_nodos
    number = @nodos.size
  end

  def has_nodos
    has = @nodos.size > 0
  end

  def index_of_nodo(a_nodo)
    index = @nodos.index(a_nodo)
    index = -1 if index.nil?
    return index
  end

  #Resetea el número de nodos
  def self.minimium_number_of_nodos
    0
  end

  #Encuentra el primero nodo que tenga oomo nombre a a_nombre 
  #
  def find_by_nombre(a_nombre)
   matches = @nodos.select{|n| n.respond_to?('nombre') and n.nombre == a_nombre}
   @match = matches.first
  end

  #Encuentra el primero nodo que tenga oomo nombre a a_nombre
  #
  def find_by_id(a_id)
   matches = @nodos.select{|n| n.id == a_id if n.respond_to?('id') }
   @match = matches.first
  end



  def find_alimentador
    return find_by_nombre("Alimentador")
  end

  def find_next_alimentador
     indice= number_of_nodos - 1
     begin
      @nodo = @nodos[indice]
      indice -= 1
     end until (  @nodo.class.to_s.include?("Alimentador") or indice == 0)

  end


  #agrega un cortorcircuito aguas abajo
  def add_nodo(a_nodo)
    fue_agregado = false
    return false if index_of_nodo(a_nodo) != -1
    @nodos << a_nodo
    fue_agregado = true
  end

  #agrega un nodo aguas abajo del ultimo
  def encola_nodo(a_nodo)
    fue_agregado = false
    return false if index_of_nodo(a_nodo) != -1
    @penultimo  = get_last_nodo
    @nodos << a_nodo
    @ultimo = get_last_nodo
    @ultimo.aguas_arriba = @penultimo if @penultimo
    @penultimo.aguas_abajo = @ultimo if @penultimo
    fue_agregado = true

    linea.info "Encolando =================="
    linea.info a_nodo.nombre
    linea.info "debajo de "
    linea.info @penultimo.nombre if @penultimo
    linea.info "=============================="
  end

 #agrega el nodo a_nodo_abajo despues del nodo a_nodo_arriba
  def encadena_nodo(a_nodo_arriba,a_nodo_abajo)
    fue_agregado = false
    return false if index_of_nodo(a_nodo_abajo) != -1
    return false if index_of_nodo(a_nodo_arriba) == -1      
    @nodos << a_nodo_abajo
    a_nodo_arriba.aguas_abajo = a_nodo_abajo
    a_nodo_abajo.aguas_arriba = a_nodo_arriba

    fue_agregado = true
    linea.info "Encadenando =================="
    linea.info a_nodo_abajo.nombre
    linea.info "debajo de "
    linea.info a_nodo_arriba.nombre
    linea.info "=============================="

  end

  def replace_or_encadena_nodo(a_ancla, a_nodo)
    nodo_existente = find_by_nombre(a_ancla.nombre)
    if nodo_existente
      a_nodo.aguas_arriba = nodo_existente.aguas_arriba
      a_nodo.aguas_abajo  = nodo_existente.aguas_abajo
      nodo_inferior = nodo_existente.aguas_abajo
      nodo_inferior.aguas_arriba = a_nodo if nodo_inferior

      replace_nodo(a_nodo, nodo_existente)
    else
      encadena_nodo(a_ancla, a_nodo)
    end
  end

  #Revisa si existe el a nodo a_nodo (buscando por su nombre), y si existe refresca los datos
  def replace_or_encola_nodo(a_nodo)
    nodo_existente =find_by_nombre(a_nodo.nombre)
    linea.info "Intentando reemplazar"
    linea.info a_nodo.nombre
    linea.info "----------------------------"
    if nodo_existente
      replace_nodo(a_nodo,nodo_existente)
      if nodo_existente.respond_to?('coci_maximo') and a_nodo.respond_to?('coci_maximo') and nodo_existente.coci_maximo and a_nodo.coci_maximo and nodo_existente.coci_maximo.icc and a_nodo.coci_maximo.icc
	  linea.info "Reemplazando iz #{nodo_existente.Iz} por #{a_nodo.Iz}"
	  linea.info "Reemplazando icc #{nodo_existente.coci_maximo.icc} por #{a_nodo.coci_maximo.icc}" 
	#_nodo.coci_maximo  = nodo_existente.coci_maximo 
      end
      #a_nodo.coci_minimo  = nodo_existente.coci_minimo if nodo_existente.respond_to?('coci_minimo')

      a_nodo.aguas_arriba = nodo_existente.aguas_arriba
      a_nodo.aguas_abajo  = nodo_existente.aguas_abajo


      #Ahora hay que actualizar los nodos que apuntan al nodo_existente
      nodo_inferior = nodo_existente.aguas_abajo
      nodo_inferior.aguas_arriba = a_nodo if nodo_inferior

      #no todos los nodos superiores apuntan a sus nodos inferiores, pero sí todos los inferiores deben apuntar a uno superior dado que es una estructura de arbol. Mas adelante veré como inventar un algoritmo con repeartidores. Por el momento estar atente a asignar aguas_abajo a a_nodo.
      nodo_superior = nodo_existente.aguas_arriba
      nodo_superior.aguas_abajo = a_nodo

      linea.info "----------------------------------------------------------"
      linea.info "Fue reemplazado el nodo #{nodo_existente.nombre} por #{a_nodo.nombre}"
      linea.info "----------------------------------------------------------"
    else
      linea.info "No existe nodo, se encolará como nuevo"
      encola_nodo(a_nodo)
    end
  end



  #agrega un nodo al arreglo de nodos pero no los encadena
  def <<(a_nodo)
    add_nodo(a_nodo)
  end

  #reemplaaza un nodo en la posicion index
  def replace_nodo(add_nodo, del_nodo)
      index = index_of_nodo(del_nodo)
      if index > 0
	@nodos.delete(del_nodo)

	@nodos.insert(index, add_nodo)
	return true
      else
	return false
      end
  end

  #Agrega un nodo en la posicion dada
  def add_or_move_nodo_at(a_nodo, index)
    if @nodos.include?(a_nodo)
      if (index < 0)
	index = 0
      end
      if (index > number_of_nodos())
	index = number_of_nodos() - 1
      end
      @nodos.delete(a_nodo)
      @nodos.insert(index, a_nodo)
    else
      add_nodo_at(a_nodo, index)
    end
  end


   def add_nodo_at(a_nodo,index)
     fue_agregado=false
     if add_nodo(a_nodo)
	if (index < 0)
	  index=0
	end
	if (index > number_of_nodos())
	  index= number_of_nodos()-1
	end
	@nodos.delete(a_nodo)
	@nodos.insert(index, a_nodo)
	fue_agregado=true
     end
     fue_agregado
   end

  #borrar todos los nodos
  def delete_all
    @deleted = true
    @nodos.each do |a_nodo|
      @nodos.delete(a_nodo)
    end
  end

  def delete_by_nombre(a_nombre)
    nodo_existente = find_by_nombre(a_nombre)
    @nodos.delete( nodo_existente) if nodo_existente
  end
end
end 
