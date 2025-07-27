class AddReasonToRewards < ActiveRecord::Migration[7.0]
  def change
    add_column :rewards, :reason, :string
  end
end
