class CreateVerifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :verifiers do |t|
      t.string :name
      t.string :runner_name
      t.string :group
      t.belongs_to :service, index: true
      t.timestamps
    end
  end
end
