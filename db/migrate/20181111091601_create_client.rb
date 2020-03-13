class CreateClient < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :clientId
    end
  end
end
