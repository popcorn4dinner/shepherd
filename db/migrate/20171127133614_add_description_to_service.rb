class AddDescriptionToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :description, :text
  end
end
