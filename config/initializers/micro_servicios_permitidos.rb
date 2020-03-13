require 'resolv'

MICRO_SERVICIOS_PERMITIDOS=ENV['MICRO_SERVICIOS_PERMITIDOS']

urls = [ "http://192.168.137.190","https://cdn.ampproject.org"]
URLS_PERMITIDAS = []

if MICRO_SERVICIOS_PERMITIDOS
  MICRO_SERVICIOS_PERMITIDOS.split.each do |s|
    if s =~ Resolv::IPv4::Regex
      urls = urls + [ "http://#{s}", "https://#{s}" ]
    else
      urls = urls + [ "https://#{s}-alectrica-cl.amp.cloudflare.com", "https://#{s}-alectrica-cl.cdn.ampproject.org","https://#{s}.alectrica.cl" ]          
    end
    URLS_PERMITIDAS = urls
  end
end
