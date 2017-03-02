class PlanSerializer < ActiveModel::Serializer
  attributes :id, :address, :description, :reference, :status, :registration_date, :decision_date
  attribute  :more_info_link, key: :link
end
