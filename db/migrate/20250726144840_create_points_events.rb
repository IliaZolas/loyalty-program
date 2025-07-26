class CreatePointsEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :points_events do |t|
      t.references :transaction, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :points

      t.timestamps
    end
  end
end
