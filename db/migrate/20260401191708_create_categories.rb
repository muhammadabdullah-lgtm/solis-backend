class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :status, null: false, default: 1
      t.references :parent, foreign_key: { to_table: :categories }, null: true

      t.timestamps
    end

    # add_index :categories, :name
    # add_index :categories, :slug, unique: true
    # add_index :categories, :status
    # add_index :categories, :parent_id
  end
end