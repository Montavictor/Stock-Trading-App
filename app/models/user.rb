class User < ApplicationRecord
  #runs method before creation of new record
  before_create :set_defaults 

  has_many :stocks
  has_many :transactions

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }

  private 

  def set_defaults
    self.is_admin = false if is_admin.nil?
    self.balance = 1000000 if balance.nil?
    self.status = false if status.nil?
  end
end