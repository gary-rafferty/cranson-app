class Plan < ApplicationRecord
  validates :status, :description, :reference, :location, :reference, :registration_date, :address, presence: true

  scope :decided, -> { where(status: 'Decided' ) }
  scope :invalid_or_withdrawn, -> { where(status: 'Invalid or Withdrawn') }
  scope :unknown, -> { where(status: 'Current status not assigned in APAS') }
  scope :pending, -> { where(status: 'Pending') }
  scope :on_appeal, -> { where(status: 'On Appeal') }
end
