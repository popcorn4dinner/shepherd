class CreateRunnerParams < ActiveRecord::Migration[5.0]
  def change
    create_table :runner_params do |t|
      t.string :name
      t.string :value
      t.belongs_to :verifier

      t.timestamps
    end
  end
end
