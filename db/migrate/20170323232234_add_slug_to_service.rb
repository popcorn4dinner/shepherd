class AddSlugToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :slug, :string
    add_index :services, :slug, unique: true
  end
end
