ActiveAdmin.register Service do

 permit_params :name,
              :health_endpoint,
              :project_id,
              :is_user_entry_point,
              :repository_url,
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
      f.input :repository_url
      f.input :is_user_entry_point, as: :boolean, default: false
    end

    f.inputs 'dependencies' do
     f.input :dependency_ids, label: 'Dependencies', as: :tags, collection: Service.all
     f.input :external_resource_ids, label: 'External Resources', as: :tags, collection: ExternalResource.all
    end

    f.actions
  end

  show do
      panel "Service Details" do
        attributes_table_for service do
          row :name
          row :project
          row :is_user_entry_point
          row :health_endpoint
          row :status do
            status_tag service.status
          end

          row :created_at
          row :updated_at
        end
      end

      panel "Dependencies" do
        attributes_table_for service do
          row 'Internal dependencies' do
            service.internal_dependencies.map do |d|
              status_tag d.name, d.status
              text_node "&nbsp;".html_safe
            end
          end

          row 'External dependencies' do
            service.external_dependencies.map do |d|
              status_tag d.name, d.status
              text_node "&nbsp;".html_safe
            end
          end

          row 'Dependency of' do
            service.dependency_of.map do |d|
              status_tag d.name, d.status
              text_node "&nbsp;".html_safe
            end
          end

          row 'Resources' do
            service.external_resources.map do |d|
              status_tag d.name, :default
              text_node "&nbsp;".html_safe
            end
          end

        end
      end

    end
end
