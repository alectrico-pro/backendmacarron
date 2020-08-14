class ::HTTPOK < Struct.new(:a); end

class ::Eldolar < Struct.new(:b)
  def valor
    DOLAR_MINIMO
  end
end



#revisa si los hosts de servicios externos están accesibles y con certificado ssl ok
#Los hosts deben configurarse en config initializers
module Ch

  class CheckHost
    include Linea 
    attr_reader :hosts
   
    #=========================
    @@hosts   = {}

    def self.check(host_name,options={}, &block)
      @@hosts[host_name] = Class.new(Ch::Host, &block)
    end

    def self.bueno( host_index, options={} )
      @@hosts[host_index].new({:host_index => host_index}.merge(options)).bueno
    end

    def self.ok( host_index, options={} )
      @@hosts[host_index].new({:host_index => host_index}.merge(options)).ok
    end

    def self.malo( host_index, options={} )
      @@hosts[host_index].new({:host_index => host_index}.merge(options)).malo
    end




    def self.get_certificado( host_index, options={} )
      @@hosts[host_index].new({:host_index => host_index}.merge(options)).get_certificado
    end

    def self.conexion( host_index, options={} )
      @@hosts[host_index].new({:host_index => host_index}.merge(options)).conexion
    end


    #=========================

    def initialize
      @hosts = { }
      check_hosts
      linea.info "Hosts investigados"
    end

    def get_tld( url )
      splitted = url.split(".").reverse
      splitted.second + (splitted.third ? ("_" + splitted.third) : '')
    end

=begin 
    def sbif
      @hosts[:"api.sbif.cl"][:conexion] and @hosts[:"api.sbif.cl"][:certificado]
    end
     
    def paypal
      @hosts[:"api.sandbox.paypal.cl"][:conexion] and @hosts[:"api.sandbox.paypal.cl"][:certificado]
    end

    def khipu
      @hosts[:"onepay.ionix.cl"][:conexion] and @hosts[:"onepay.ionix.cl"][:certificado]
    end

    def onepay
      @hosts[:"onepay.ionix.cl"][:conexion] and @hosts[:"onepay.ionix.cl"][:certificado]
    end
=end
    def check_hosts
      resultado=false

      MIS_HOSTS.split.each do |host|

        conexion = true
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

        if conexion
          certprops = OpenSSL::X509::Name.new(cert.issuer).to_a
          issuer = certprops.select { |name, data, type| name == "O" }.first[1]
          results = {
            valid_on: cert.not_before,
            valid_until: cert.not_after,
            issuer: issuer,
            valid: (ssl_client.verify_result == 0)
          }

          if results[:valid_until] > Time.now
            certificado=true
          else
            certificado=false
          end
        end

        host = { host.to_sym => { :tld => self.get_tld(host) ,:conexion => conexion , :certificado => certificado } }
        @hosts = @hosts.merge host
        resultado = resultado and certificado and conexion
      end
      return resultado
    end
  end
end
