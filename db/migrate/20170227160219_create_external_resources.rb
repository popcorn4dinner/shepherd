class CreateExternalResources < ActiveRecord::Migration[5.0]
  def change
    create_table :external_resources do |t|
      t.string :name

      t.timestamps
    end
  end
end
