class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :post_genre
      t.string :item_genre
      t.string :price
      t.string :status
      t.text :memo

      t.timestamps
    end
  end
end
