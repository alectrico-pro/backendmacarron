module Ch
  class Check < CheckHost
    include Linea

    def self.get_tld( url )
      splitted = url.split(".").reverse
      splitted.second + (splitted.third ? ("_" + splitted.third) : '')
    end


    MIS_HOSTS.split.each do |host|
      tld = self.get_tld( host )


      check tld.to_sym do
        def malo
          bueno
          not bueno
        end
      end

    end


  end
end


