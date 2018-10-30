class Response < ApplicationRecord
  include Wisper::Publisher
  subscribe(RequestStatusPolicy.new, async: true)
  # publish response creation
  after_commit :apply_request_policy, on: :create

  enum status: [:posted, :delivered]

  belongs_to :request
  belongs_to :user

  validates :request, presence: true
  validates :user, presence: true

  has_one :fulfillment

  def self.with_fulfillment
    eager_load(:fulfillment)
  end

  def self.with_request
    joins(:request).eager_load(:request)
  end

  def self.with_user
    withUser
  end

  def self.all_for_user(user: required)
    # created_at represents the time the request is posted
    forUser(user.id).order("#{table_name}.created_at desc")
  end

  private

  def apply_request_policy
    # "fire and forget"
    # call the dispatcher method to update request status if rules apply
    publish(:apply_to_new_response, request_id)
  end
end
