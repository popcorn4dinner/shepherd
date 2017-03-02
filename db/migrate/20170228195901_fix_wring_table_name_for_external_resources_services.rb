class FixWringTableNameForExternalResourcesServices < ActiveRecord::Migration[5.0]
  def up
    create_join_table :external_resources, :services do |t|
      # t.index [:service_id, :external_dependency_id]
       #t.index [:external_dependency_id, :service_id]
    end

    drop_table :external_dependencies_services
  end
end
