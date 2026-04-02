class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :status, {
    pending:   0,
    confirmed: 1,
    shipped:   2,
    delivered: 3,
    cancelled: 4
  }

  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :currency,    presence: true
  validates :full_name,   presence: true
  validates :phone,       presence: true
  validates :street,      presence: true
  validates :city,        presence: true
  validates :country,     presence: true

  def cancellable?
    pending?
  end
end
