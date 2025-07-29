class Transaction < ApplicationRecord
  belongs_to :user

  validates :company_name, presence: true
  validates :stock_price, presence: true
  validates :quantity, presence: true
  validates :total_price, presence: true
  validates :transaction_type, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id stock_symbol quantity price total transaction_type created_at updated_at company_name]
  end 
    
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
