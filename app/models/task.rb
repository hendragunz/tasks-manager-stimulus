class Task < ApplicationRecord
  validates :description, presence: true

  scope :recent,    -> { order(created_at: :desc) }
  scope :completed, -> { where(completed: true).recent }
  scope :todo,      -> { where(completed: false).recent }

end
