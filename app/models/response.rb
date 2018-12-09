class Response < ApplicationRecord
  include Wisper::Publisher
  subscribe(RequestStatusPolicy.new, async: Rails.env.production?)
  subscribe(JobDispatcher.new, async: Rails.env.production?)
  # announce response creation to listeners
  after_commit :publish_created, on: :create
  after_commit :publish_destroyed, on: :destroy

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
    joins(:request).eager_load([:request, {:request => :user}])
  end


  def self.with_user
    withUser
  end

  def self.all_for_user(user: required)
    # created_at represents the time the request is posted
    forUser(user.id).order("#{table_name}.created_at desc")
  end

  private

  def publish_created
    publish :response_create
    publish(:response_new_notify, self.extend(ResponseView).async)
    publish(:apply_to_new_response, request_id)
  end

  def publish_destroyed
    publish :response_destroy
  end
end
