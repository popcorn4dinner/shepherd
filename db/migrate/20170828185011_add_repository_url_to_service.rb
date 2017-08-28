class AddRepositoryUrlToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :repository_url, :string
  end
end
