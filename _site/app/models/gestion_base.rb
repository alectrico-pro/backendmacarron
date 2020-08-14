class GestionBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection DB_GESTION
  def self.table_name_prefix
    'gestion_'
  end


end
