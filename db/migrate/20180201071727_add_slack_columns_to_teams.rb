class AddSlackColumnsToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :webhook_url, :string
    add_column :teams, :channel_name, :string
  end
end
