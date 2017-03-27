class AddSlugToExternalResource < ActiveRecord::Migration[5.0]
  def change
    add_column :external_resources, :slug, :string
    add_index :external_resources, :slug, unique: true
  end
end
