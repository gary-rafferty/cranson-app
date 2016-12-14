class Plan < ApplicationRecord
  validates :status, :description, :reference, :location, :reference, :registration_date, presence: true

  scope :decided, -> { where(status: 'Decided' ) }
end
