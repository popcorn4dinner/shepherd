class CreateVerifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :verifiers do |t|
      t.string :name
      t.string :url
      t.string :runner
      t.string :type
      t.belongs_to :service, index: true
      t.timestamps
    end
  end
end
