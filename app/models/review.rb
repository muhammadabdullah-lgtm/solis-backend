class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :user_id, uniqueness: { scope: :product_id, message: 'has already reviewed this product' }
  validate :user_must_have_delivered_order_for_product

  private

  def user_must_have_delivered_order_for_product
    return if user.blank? || product.blank?

    purchased = OrderItem
      .joins(:order)
      .where(product_id: product.id, orders: { user_id: user.id, status: Order.statuses[:delivered] })
      .exists?

    unless purchased
      errors.add(:base, 'You can only review products from delivered orders')
    end
  end
end
