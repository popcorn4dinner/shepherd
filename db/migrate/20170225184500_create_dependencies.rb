class CreateDependencies < ActiveRecord::Migration[5.0]
  def change
    create_table :dependencies do |t|
      t.integer :type
      t.references :service, foreign_key: true
      t.integer :dependency_id, foreign_key: true

      t.timestamps
    end
  end
end
