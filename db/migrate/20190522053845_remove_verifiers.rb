class RemoveVerifiers < ActiveRecord::Migration[5.0]
  def change
    drop_table :verifiers
    drop_table :runner_params
  end
end
