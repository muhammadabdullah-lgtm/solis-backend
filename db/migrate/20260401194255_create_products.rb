class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sku, null: false

      t.string :short_description
      t.text :description
      t.string :image_url, null: false

      t.references :category, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.decimal :price, precision: 12, scale: 2, null: false, default: 0
      t.decimal :compare_at_price, precision: 12, scale: 2
      t.decimal :cost_price, precision: 12, scale: 2

      t.integer :stock_quantity, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.boolean :is_featured, null: false, default: false
      t.string :currency, null: false, default: 'AED'

      t.string :meta_title
      t.string :meta_description

      t.timestamps
    end

    # add_index :products, :slug, unique: true
    # add_index :products, :sku, unique: true
    # add_index :products, :status
    # add_index :products, :price
    # add_index :products, :is_featured
    # add_index :products, [:category_id, :brand_id]
  end
end