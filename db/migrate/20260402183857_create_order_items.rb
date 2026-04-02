class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.references :order,   null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      # Product snapshot — preserves values at the time the order was placed
      t.string  :product_name,      null: false
      t.string  :product_sku,       null: false
      t.string  :product_image_url, null: false
      t.decimal :unit_price, null: false, precision: 12, scale: 2
      t.integer :quantity,   null: false
      t.decimal :subtotal,   null: false, precision: 12, scale: 2

      t.timestamps
    end

    add_index :order_items, [:order_id, :product_id], unique: true
  end
end
