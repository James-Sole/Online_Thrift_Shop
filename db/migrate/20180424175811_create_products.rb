class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :item
      t.integer :amount
      t.integer :seller_id
      t.integer :buyer_id

      t.timestamps null: false
    end
  end
end
