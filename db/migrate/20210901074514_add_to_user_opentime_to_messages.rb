class AddToUserOpentimeToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :to_user_opentime, :timestamp
  end
end
