ActiveAdmin.register Service do


 permit_params :name, :heath_endpoint, :service_ids, :external_resource_ids


form do |f|
    f.inputs 'Service' do
      f.input :name
      f.input :health_endpoint

    end
    f.inputs 'dependencies' do
     f.input :dependencies ,as: :tags, collection: Service.all
    end

    f.inputs 'external resources' do
      f.input :external_resources, as: :tags, collection: ExternalResource.all
    end

    f.actions
  end

end
