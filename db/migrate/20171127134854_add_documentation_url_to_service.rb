class AddDocumentationUrlToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :documentation_url, :string
  end
end
