class AddAddressToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :address, :string
  end
end
