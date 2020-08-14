CFG = YAML::load(ERB.new(File.read(Rails.root.join("config","cfg.yml"))).result)[Rails.env]

