class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
