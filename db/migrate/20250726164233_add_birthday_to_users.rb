class AddBirthdayToUsers < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:users, :birthday)
    add_column :users, :birthday, :date
    end
  end
end
