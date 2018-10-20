class Request < ApplicationRecord

  enum category: [:one_time_task, :material_need]
  enum status: [:active, :pending, :fulfilled]

  validates :title, presence: true, length: { maximum: 100, message: 'cannot be longer than 100 characters.'}

  validates :description, presence: true, length: { maximum: 500, message: 'cannot be longer than 500 characters.'}

  validates :address, presence: true

  validates :category, inclusion: {
      in: categories,
      message: 'A request needs to be of type one_time_task or material_need'
  }

  validates :status, inclusion: {
      in: statuses,
      message: 'A request needs to in status active, pending, or fulfilled'
  }

  
end
