class CreateAuthorities < ActiveRecord::Migration[5.0]
  def change
    create_table :authorities do |t|
      t.string :name

      t.timestamps
    end
  end
end
