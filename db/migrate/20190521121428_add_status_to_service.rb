class AddStatusToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :status, :integer, default: 1
    remove_column :services, :health_endpoint
  end
end
