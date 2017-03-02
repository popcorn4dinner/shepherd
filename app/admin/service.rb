ActiveAdmin.register Service do

 permit_params :name,
              :health_endpoint,
              :project_id,
              dependency_ids: [],
              external_resource_ids: []
 index do
   column :name
   column :status do |service|
     status_tag service.status
   end
   column :project
   actions

 end

 form do |f|

    f.inputs 'Service' do
      f.input :name
      f.input :project
      f.input :health_endpoint
    end

    f.inputs 'dependencies' do
     f.input :dependency_ids, as: :tags, collection: Service.all
     f.input :external_resource_ids, as: :tags, collection: ExternalResource.all
    end

    f.actions
  end

end
