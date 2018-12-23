class Account < ApplicationRecord
  include Wisper::Publisher
  subscribe(JobDispatcher.new, async: Rails.env.production?)
  after_commit :publish_verified, on: :create

  belongs_to :user
  validates :user_id, uniqueness: true

  # Add the attribute ":pic" with a file attachment
  has_attached_file :pic
  before_post_process { pic_content_type.match? %r{\Aimage\/.*\z} }

  # Validate the attached image is jpg, png, or pdf
  validates_attachment_content_type :pic, :content_type => /\Aapplication\/.*pdf|image\/.*jp.*g|image\/.*png\z/i

  private

  def publish_verified
    publish(:account_verification_notify, self.extend(AccountView).async)
  end

end

