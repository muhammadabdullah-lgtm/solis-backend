class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand

  enum :status, { draft: 0, active: 1, archived: 2 }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :sku, presence: true, uniqueness: true
  validates :image_url, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :compare_at_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :cost_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true

  validate :category_must_be_leaf_category
  validate :compare_at_price_must_be_greater_than_or_equal_to_price

  scope :active, -> { where(status: :active) }
  scope :featured, -> { where(is_featured: true) }
  scope :in_stock, -> { where("stock_quantity > 0") }

  before_validation :generate_slug

  def in_stock?
    stock_quantity.to_i > 0
  end

  private

  def generate_slug
    self.slug = name.to_s.parameterize if slug.blank? && name.present?
  end

  def category_must_be_leaf_category
    return if category.blank?

    if category.subcategories.exists?
      errors.add(:category_id, 'must be a subcategory or leaf category')
    end
  end

  def compare_at_price_must_be_greater_than_or_equal_to_price
    return if compare_at_price.blank? || price.blank?

    if compare_at_price < price
      errors.add(:compare_at_price, 'must be greater than or equal to price')
    end
  end
end