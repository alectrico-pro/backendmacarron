#ttp://www.ostinelli.net/setting-multiple-databases-rails-definitive-guide/
DB_GESTION = YAML::load(ERB.new(File.read(Rails.root.join("config","database_gestion.yml"))).result)[Rails.env]

