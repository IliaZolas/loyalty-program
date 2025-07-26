class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :reward_type
      t.datetime :issued_at

      t.timestamps
    end
    add_index :rewards, :issued_at
  end
end
