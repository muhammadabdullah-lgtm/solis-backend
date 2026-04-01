class CreateBrands < ActiveRecord::Migration[7.2]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :status, null: false, default: 1

      t.timestamps
    end

    add_index :brands, :name
    add_index :brands, :slug, unique: true
    add_index :brands, :status
  end
end