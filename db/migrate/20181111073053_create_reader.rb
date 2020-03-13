class CreateReader < ActiveRecord::Migration[5.1]
  def change
    create_table :readers do |t|
      t.string :rid
    end
  end
end
