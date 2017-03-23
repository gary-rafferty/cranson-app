class ChangePlanDescriptionFromStringToText < ActiveRecord::Migration[5.0]
  def change
    change_column :plans, :description, :text
  end
end
