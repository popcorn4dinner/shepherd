class AddIsEntryPointToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :is_user_entry_point, :boolean
  end
end
