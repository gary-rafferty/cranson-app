class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :status
      t.date :decision_date
      t.string :description
      t.st_point :location
      t.string :more_info_link
      t.string :reference
      t.date :registration_date

      t.timestamps
    end
  end
end
