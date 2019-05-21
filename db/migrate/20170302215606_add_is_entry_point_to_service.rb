class AddIsEntryPointToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :is_user_entry_point, :boolean
    remove_column :services, :health_endpoint
  end
end
