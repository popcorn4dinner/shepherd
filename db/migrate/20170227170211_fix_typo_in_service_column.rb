class FixTypoInServiceColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :services, :heath_endpoint, :health_endpoint
  end
end
