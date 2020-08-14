#revisa si los hosts de servicios externos están accesibles y con certificado ssl ok
#Los hosts deben configurarse en config initializers
module Ch

  class Host

    def get_tld( url )
      splitted = url.split(".").reverse
      splitted.second + (splitted.third ? ("_" + splitted.third) : '')
    end

    def initialize(options)
      @host_index = options[:host_index]
    end

    def ok
      raise "Not Implemented"
    end

    def malo
      raise "Not Implemented"
    end

    def bueno

      cert = ''

      MIS_HOSTS.split.each do |host|
        tld = get_tld( host )

        if @host_index == tld.to_sym
          linea.info "Verificando #{host}"

          begin
            tcp_client = TCPSocket.new(host, 443)
            ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client)
            ssl_client.hostname = host
            ssl_client.connect
            cert = OpenSSL::X509::Certificate.new(ssl_client.peer_cert)
            ssl_client.sysclose
            tcp_client.close
          rescue StandardError => e
            puts e.inspect
            linea.error "#{host} fail"
            return false

          end
        end

        unless cert.blank?
          certprops = OpenSSL::X509::Name.new(cert.issuer).to_a
          issuer = certprops.select { |name, data, type| name == "O" }.first[1]

          results = {
            valid_on: cert.not_before,
            valid_until: cert.not_after,
            issuer: issuer,
            valid: (ssl_client.verify_result == 0)
          }

          if results[:valid_until] > Time.now
            linea.info "ok"
            return true
          else
            linea.error "fail"
            return false
          end

        end
      end
        
    end

    def get_certificado
      #Estable conexión ssl y extrae el certificado. Devuelve '' si no puede.
      cert = ''

      MIS_HOSTS.split.each do |host|
        tld = get_tld( host )

        if @host_index == tld.to_sym
          begin
            tcp_client = TCPSocket.new(host, 443)
            ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client)
            ssl_client.hostname = host
            ssl_client.connect
            cert = OpenSSL::X509::Certificate.new(ssl_client.peer_cert)
            ssl_client.sysclose
            tcp_client.close
          rescue StandardError => e
            linea.info "#{e.inspect}"
            linea.error "#{host} fail"
            conexion=false
          end
        end

      end
      return cert
    end

    #Prueba si se puede abrir una conexión tcp
    def conexion
      conexion = false

      MIS_HOSTS.split.each do |host|
        tld = get_tld( host )

        if @host_index == tld.to_sym
          byebug
          conexion = true
          begin
            tcp_client = TCPSocket.new(host, 443)
            tcp_client.close
          rescue StandardError => e
            puts e.inspect
            conexion=false
          end
        end

      end

      return conexion

    end
  end
 
end
