class Transaction < ApplicationRecord
  belongs_to :user

  validates :company_name, presence: true
  validates :stock_price, presence: true
  validates :quantity, presence: true
  validates :total_price, presence: true
  validates :transaction_type, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id user_id quantity stock_price total_price
      transaction_type company_name created_at updated_at
    ]
  end
    
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
