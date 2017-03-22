class AddDefaultValueToIsUserEntryPoint < ActiveRecord::Migration[5.0]
  def change
    change_column :services, :is_user_entry_point, :boolean, :default => false
  end
end
