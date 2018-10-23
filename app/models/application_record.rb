class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  scope :forUser, -> (userId) { where("#{table_name}.user_id = ?", userId) }
end
