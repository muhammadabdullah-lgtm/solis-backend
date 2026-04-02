class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer    :rating,  null: false
      t.text       :body

      t.timestamps
    end

    # One review per product per user
    add_index :reviews, [:user_id, :product_id], unique: true
    add_index :reviews, :rating
  end
end
