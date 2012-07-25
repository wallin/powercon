class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.integer :consumption
      t.integer :user_id

      t.timestamps
    end
  end
end
