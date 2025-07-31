class User < ApplicationRecord
  #runs method before creation of new record
  before_create :set_defaults 

  has_many :stocks, dependent: :nullify
  has_many :transactions, dependent: :nullify

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validate :password_optional_on_update
  

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id username email balance is_admin status created_at updated_at]
  end

  # Scoping
  scope :pending, ->  {where(status: false).order(:created_at)}


  private 

  def set_defaults
    self.is_admin = false if is_admin.nil?
    self.balance = 1000000 if balance.nil?
    self.status = false if status.nil?
  end

  def password_optional_on_update
    return if new_record?
    return if password.blank?
    if password.length < Devise.password_length.min
      errors.add(:password, "is too short (minimum is #{Devise.password_length.min} characters)")
    end
  end
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end