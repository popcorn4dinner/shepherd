ActiveAdmin.register Service do

 permit_params :name,
              :health_endpoint,
              :project_id,
              dependency_ids: [:id],
              external_resource_ids: [:id]

  before_create :sanitize_habtm_ids
  before_update :sanitize_habtm_ids

  controller do
    def sanitize_habtm_ids(arg)
      ["dependency_ids","external_resource_ids"].each do |attribute|
        unless params[attribute].nil?
          params[attribute].reject{ |c| c.empty? }
        end
      end
    end
  end

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
