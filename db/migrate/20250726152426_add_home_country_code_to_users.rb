class AddHomeCountryCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :home_country_code, :string
  end
end
