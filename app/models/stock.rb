class Stock < ApplicationRecord
  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
    ["company_name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
