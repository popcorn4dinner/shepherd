class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name
      t.string :heath_endpoint
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
