class Fulfillment < ApplicationRecord
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)

  after_commit :publish_destroyed, on: :destroy

  belongs_to :response
  belongs_to :request
  belongs_to :user

  validates :response, presence: true, uniqueness: true
  validates :request, presence: true, uniqueness: true
  validates :user, presence: true

  private

  def publish_destroyed
    publish :fulfillment_destroy
  end
end
