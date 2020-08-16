class Cfg
  def initialize
    @cfg = YAML::load(ERB.new(File.read(Rails.root.join("config","cfg.yml"))).result)[Rails.env]
  end
  def method_missing(arg)
    if @cfg.key?(arg.to_s) 
      return @cfg[arg.to_s]
    end
  end
  def ok?
    @cfg.key?('ok') 
  end
end
