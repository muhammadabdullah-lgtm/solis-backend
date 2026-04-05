class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: :parent_id, dependent: :nullify

  has_many :products, dependent: :restrict_with_exception

  enum :status, { inactive: 0, active: 1 }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  validate :parent_cannot_be_self
  validate :max_depth_three_levels

  scope :active, -> { where(status: :active) }
  scope :root_categories, -> { where(parent_id: nil) }
  scope :children_categories, -> { where.not(parent_id: nil) }

  before_validation :generate_slug

  def root?
    parent_id.nil?
  end

  def child?
    parent_id.present?
  end

  def depth
    return 0 if parent.blank?
    1 + parent.depth
  end

  private

  def generate_slug
    self.slug = name.to_s.parameterize if slug.blank? && name.present?
  end

  def parent_cannot_be_self
    return if id.nil?
    errors.add(:parent_id, 'cannot be same as category') if parent_id == id
  end

  def max_depth_three_levels
    return if parent.blank?
    if parent.depth >= 2
      errors.add(:parent_id, 'maximum category nesting is 3 levels')
    end
  end
end