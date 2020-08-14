#https://blog.codeship.com/producing-documentation-for-your-rails-api/
RspecApiDocumentation.configure do |config|
  #Output folder
  config.docs_dir = Rails.root.join("doc", "_data", "api")
 # Possible values are :json, :html, :combined_text, :combined_json,
  #   #   :json_iodocs, :textile, :markdown, :append_json
  config.format = [:json]
  config.filter = :public #requiere examples "ex", :document => [:public]
  #no me funciona el filtro
end
