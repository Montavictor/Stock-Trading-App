class Transaction < ApplicationRecord
  belongs_to :user

  validates :company_name, presence: true
  validates :stock_price, presence: true
  validates :quantity, presence: true
  validates :total_price, presence: true
  validates :transaction_type, presence: true
end
