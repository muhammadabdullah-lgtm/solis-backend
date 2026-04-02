class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer    :status,      null: false, default: 0
      t.decimal    :total_price, null: false, precision: 12, scale: 2
      t.string     :currency,    null: false, default: 'AED'

      # Delivery address — captured as a snapshot at order time (not stored in a separate table)
      t.string :full_name,   null: false
      t.string :phone,       null: false
      t.string :street,      null: false
      t.string :city,        null: false
      t.string :state
      t.string :country,     null: false
      t.string :postal_code

      t.text :notes

      t.timestamps
    end

    add_index :orders, [:user_id, :created_at]
    add_index :orders, :status
  end
end
