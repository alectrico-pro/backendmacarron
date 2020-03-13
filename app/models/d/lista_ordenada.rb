#Es una mejora de la lista genérica para que pueda ordenar 
 class D::ListaOrdenada < D::Lista

   def initialize
     super
   end


   def add_nodo_ordenado_por_metodo(a_nodo,a_method)
     if !has_nodos then
       add_nodo(a_nodo)
     else
       last = get_last_nodo
       if last.send(a_method) <= a_nodo.send(a_method)
	 add_nodo(a_nodo)
       else
	 s=get_nodos.select{|n| n.send(a_method) > a_nodo.send(a_method) }
	 add_or_move_nodo_at(a_nodo, index_of_nodo(s.first))
       end
     end
   end

   def add_nodo_ordenado_potencia_nominal(a_nodo)
     if !has_nodos then
      add_nodo(a_nodo)
     else
       last = get_last_nodo
       if last.potencia_nominal <= a_nodo.potencia_nominal
         add_nodo(a_nodo)
       else
         s=get_nodos.select{|n| n.potencia_nominal > a_nodo.potencia_nominal}
         add_or_move_nodo_at(a_nodo, index_of_nodo(s.first))
       end
     end

   end


   def add_nodo_ordenado_in(a_nodo)
     if !has_nodos then
      add_nodo(a_nodo)
     else
       last = get_last_nodo
       if last.In <= a_nodo.In
         add_nodo(a_nodo)
       else
         s=get_nodos.select{|n| n.In > a_nodo.In}
         add_or_move_nodo_at(a_nodo, index_of_nodo(s.first))
       end
     end
   end

   def add_nodo_ordenado(a_nodo)
     #LOG.debug "#{a_nodo.modelo} Pdc #{a_nodo.pdc} In #{a_nodo.In}"
     if !has_nodos then
      add_nodo(a_nodo)
     else
       last = get_last_nodo
       if last.pdc <= a_nodo.pdc
         add_nodo(a_nodo)
       else
         s=get_nodos.select{|n| n.pdc > a_nodo.pdc}
         add_or_move_nodo_at(a_nodo, index_of_nodo(s.first))
       end
     end
   end


  end
