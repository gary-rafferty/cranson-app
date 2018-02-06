class AddAuthorityIdToPlans < ActiveRecord::Migration[5.0]
  def change
    add_reference :plans, :authority, index: true
    
    Plan.update_all(authority_id: Authority.find_by(name: 'Fingal County Council').id)
  end
end
