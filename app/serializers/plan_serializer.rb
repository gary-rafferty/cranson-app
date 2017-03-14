class PlanSerializer < ActiveModel::Serializer
  attributes :id, :address, :description, :reference, :status, :registration_date, :decision_date
  attribute :audits, if: :include_audits?
  attribute :more_info_link, key: :link

  def include_audits?
    @instance_options.fetch(:with_audits, false)
  end

  def audits
    object.audits.map do |audit|
      {
        changes: audit.audited_changes,
        changed_at: audit.created_at
      }
    end
  end
end
