class Plan < ApplicationRecord
  include PgSearch
  
  validates :status, :description, :reference, :location, :reference, :registration_date, :address, presence: true

  scope :decided, -> { where(status: 'Decided' ) }
  scope :invalid_or_withdrawn, -> { where(status: 'Invalid or Withdrawn') }
  scope :unknown, -> { where(status: 'Current status not assigned in APAS') }
  scope :pending, -> { where(status: 'Pending') }
  scope :on_appeal, -> { where(status: 'On Appeal') }

  default_scope { order(registration_date: :desc) }

  pg_search_scope :search_by_address, against: :address
  
  class << self
    def persist(plan)
      attributes = {
        reference: plan.planning_reference,
        description: plan.description,
        address: plan.location,
        location: "POINT(#{plan.lat} #{plan.long})",
        status: plan.current_status,
        more_info_link: plan.more_information,
        registration_date: plan.registration_date,
        decision_date: plan.decision_date,
      }

      begin
        self.find_or_create_by(attributes)
      rescue ActiveRecord::StatementInvalid
      end
    end
  end
end
