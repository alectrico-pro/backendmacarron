class AddUserRefToReaders < ActiveRecord::Migration[5.1]
  def change
    add_reference :readers, :user, foreign_key: true
  end
end
