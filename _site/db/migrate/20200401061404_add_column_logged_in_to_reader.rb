class AddColumnLoggedInToReader < ActiveRecord::Migration[5.1]
  def change
    add_column :readers, :logged_in, :boolean
  end
end
