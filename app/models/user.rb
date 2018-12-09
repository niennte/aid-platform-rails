class User < ApplicationRecord
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)
  after_commit :publish_user_account_created, on: :create
  after_commit :publish_user_account_destroyed, on: :destroy

  has_many :requests
  has_many :responses
  has_many :fulfillments

  validates :username, presence: true, uniqueness: true
  validates_presence_of :password_confirmation, :on => :create
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

  private

  def publish_user_account_created
    publish :user_create
  end

  def publish_user_account_destroyed
    publish :user_destroy
  end
end
