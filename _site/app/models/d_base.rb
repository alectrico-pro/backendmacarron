  class DBase < ActiveRecord::Base
    self.abstract_class = true
    establish_connection DB_ELECTRICO
  end
