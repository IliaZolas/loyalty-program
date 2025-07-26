class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :country_code
      t.datetime :occurred_at

      t.timestamps
    end
  end
end
