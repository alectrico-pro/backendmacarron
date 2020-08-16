require 'resolv'

MICRO_SERVICIOS_PERMITIDOS=ENV['MICRO_SERVICIOS_PERMITIDOS']

urls = [ "http://192.168.137.190","https://cdn.ampproject.org"]

if MICRO_SERVICIOS_PERMITIDOS

  MICRO_SERVICIOS_PERMITIDOS.split.each do |s|

    if s =~ Resolv::IPv4::Regex
      urls = urls + [ "http://#{s}", "https://#{s}" ]
    else
      urls = urls + [ "https://#{s}-#{Cfg.dominio.gsub('.','-')}.amp.cloudflare.com", "https://#{s}-#{Cfg.dominio.gsub('.','-')}.cdn.ampproject.org","https://#{s}.#{Cfg.dominio}","https://#{s}.#{Cfg.dominio}" ]          
    end

  end

  if urls
    URLS_PERMITIDAS = urls 
  else
    URLS_PERMITIDAS = []
  end

else

  URLS_PERMITIDAS = []

end
