class Plan < ApplicationRecord
  include PgSearch

  audited except: [:location, :authority_id], on: :update

  belongs_to :authority

  validates :status, :description, :reference, :location, :reference, :registration_date, :address, presence: true

  scope :decided, -> { where(status: 'Decided' ) }
  scope :invalid_or_withdrawn, -> { where(status: 'Invalid or Withdrawn') }
  scope :unknown, -> { where(status: 'Current status not assigned in APAS') }
  scope :pending, -> { where(status: 'Pending') }
  scope :on_appeal, -> { where(status: 'On Appeal') }
  scope :within_kilometres_of, -> (kilometres, latlon) {
    where(
      "ST_DWithin(location::geography, \'POINT(#{latlon.join(' ')})\'::geography, #{kilometres.to_i * 1000})"
    )
  }
  scope :recently_registered, -> { where("registration_date > ?", 1.month.ago.to_date) }
  scope :recently_decided, -> { where("decision_date > ?", 1.month.ago.to_date) }

  default_scope { order(registration_date: :desc) }

  pg_search_scope :search_by_address, against: :address

  class << self
    def persist(_plan, authority)
      plan = Plan.where(reference: _plan.planning_reference).first_or_initialize

      plan.reference         =  _plan.planning_reference
      plan.description       =  _plan.description
      plan.address           =  _plan.location
      plan.location          =  "POINT(#{_plan.lat} #{_plan.long})"
      plan.status            =  _plan.current_status
      plan.more_info_link    =  _plan.more_information
      plan.registration_date =  _plan.registration_date
      plan.decision_date     =  _plan.decision_date
      plan.authority_id      =  authority.id

      return unless (plan.changed? or plan.new_record?)

      plan.save!

    rescue ActiveRecord::RecordInvalid => e
      logger.error e
    end
  end
end
