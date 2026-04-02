class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :product_must_be_active
  validate :quantity_must_not_exceed_stock

  private

  def product_must_be_active
    return if product.blank?

    unless product.active?
      errors.add(:product, 'is not available')
    end
  end

  def quantity_must_not_exceed_stock
    return if product.blank? || quantity.blank?

    if quantity > product.stock_quantity
      errors.add(:quantity, "cannot exceed available stock (#{product.stock_quantity})")
    end
  end
end
