class User < ApplicationRecord

  validates :username, presence: true, uniqueness: true
  validates_presence_of :password_confirmation
  validates_confirmation_of :password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :timeoutable,
         :validatable,
         :lockable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist
end
