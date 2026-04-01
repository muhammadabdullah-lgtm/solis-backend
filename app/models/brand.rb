class Brand < ApplicationRecord
  has_many :products, dependent: :restrict_with_exception

  enum :status, { inactive: 0, active: 1 }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(status: :active) }

  before_validation :generate_slug

  private

  def generate_slug
    self.slug = name.to_s.parameterize if slug.blank? && name.present?
  end
end