class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_name,      presence: true
  validates :product_sku,       presence: true
  validates :product_image_url, presence: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity,   presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :subtotal,   presence: true, numericality: { greater_than_or_equal_to: 0 }
end
