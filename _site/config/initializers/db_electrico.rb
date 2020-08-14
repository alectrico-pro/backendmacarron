#ttp://www.ostinelli.net/setting-multiple-databases-rails-definitive-guide/
::DB_ELECTRICO = YAML::load(ERB.new(File.read(Rails.root.join("config","database_electrico.yml"))).result)[Rails.env]

