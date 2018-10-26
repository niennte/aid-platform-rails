class Request < ApplicationRecord

  enum category: [:one_time_task, :material_need]
  enum status: [:active, :pending, :closed]

  validates :title, presence: true, length: { maximum: 100, message: 'cannot be longer than 100 characters.'}

  validates :description, presence: true, length: { maximum: 500, message: 'cannot be longer than 500 characters.'}

  validates :address, presence: true

  validates :category, inclusion: {
      in: categories,
      message: 'A request needs to be of type either one_time_task or material_need'
  }

  validates :status, inclusion: {
      in: statuses,
      message: 'A request needs to have status of either active, pending, or fulfilled'
  }

  belongs_to :user
  has_many :responses
  has_one :fulfillment

  # geocoder gem methods
  geocoded_by :address do |obj,results|
    if geo = results.first
      obj.full_address = geo.address
      obj.city    = geo.city
      obj.postal_code = geo.postal_code
      obj.country = geo.country_code
      obj.lng = geo.longitude
      obj.lat = geo.latitude
    end
  end

  # to validate address validity, call the service
  # after model validation is complete
  after_validation :geocode, if: :address_changed?
  after_validation :coordinates_changed?

  def self.all_for_user(user: required)
    # created_at represents the time the request is posted
    forUser(user.id).order('created_at desc')
  end

  def self.with_user_and_num_responses
    select("#{table_name}.*, users.username as user_name, fulfillments.id as is_fulfilled, count(responses.id) as num_responses")
        .joins(:user)
        .joins("LEFT OUTER JOIN responses ON #{table_name}.id = responses.request_id")
        .joins("LEFT OUTER JOIN fulfillments ON #{table_name}.id = fulfillments.request_id")
        .group("#{table_name}.id, users.id, fulfillments.id")
  end

  def self.with_user
    withUser
  end

  def self.with_fulfillment
    eager_load(:fulfillment)
  end

  def self.all_active
    where(status: :active)
  end

  def self.with_num_responses
    select("#{table_name}.*, count(responses.id) as num_responses")
        .joins("LEFT OUTER JOIN responses ON #{table_name}.id = responses.request_id")
        .group("#{table_name}.id")
  end

  private

  # Validate whether the address has been successfully parsed.
  # courtesy of:
  # https://stackoverflow.com/questions/23090430/geocoder-rails-check-if-valid
  # This is used to make sure that our address is actually parsed properly and we
  # get a valuable lat/long
  def coordinates_changed?
    if self.address_changed?
      unless self.lat_changed? || self.lng_changed?
        self.errors.add(:address, 'cannot be geo-located. Try to be more specific')
        return false
      end
    end
    true
  end
end
