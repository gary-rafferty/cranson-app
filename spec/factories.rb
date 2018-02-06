FactoryBot.define do

  factory :authority do
    name "Authority One"
  end

  factory :plan do
    status "Decided"
    decision_date "2016-12-13"
    description "Construction of new dwelling"
    location "POINT(53.3498 6.2603)"
    more_info_link "http://moreinfolink.ie"
    reference "ABC/123"
    registration_date "2016-12-13"
    address "1 Big Street, Co. Dublin"

    authority
  end
end
