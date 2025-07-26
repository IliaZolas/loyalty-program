class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :api_key

      t.timestamps
    end
    add_index :clients, :api_key
  end
end
