class ElectricoBase < ActiveRecord::Base
  include Linea

  self.abstract_class = true

  establish_connection ::DB_ELECTRICO 

  def self.table_name_prefix
    ''
  end
end
