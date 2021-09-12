class AddToUserIdToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :to_user_id, :integer
  end
end
