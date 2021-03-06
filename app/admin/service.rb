ActiveAdmin.register Service do

 permit_params :name,
               :description,
               :project_id,
               :is_user_entry_point,
               :repository_url,
               external_resource_ids: [],
               dependency_ids: []


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
      f.input :description, as: :text
      f.input :repository_url
      f.input :is_user_entry_point, as: :boolean, default: false
    end

    f.inputs 'dependencies' do
     f.input :dependency_ids, label: 'Dependencies', collection: Service.all, multiple: true
     f.input :external_resource_ids, label: 'External Resources', collection: ExternalResource.all, multiple: true
    end

    f.actions
  end

  show do
      panel "Service Details" do
        attributes_table_for service do
          row :name
          row :project
          row :documentation do
            documentation_url = service.documentation_url ||
                                service.repository_url.sub(':', '/').sub('git@', 'http://').sub('.git', '')
            link_to 'click here', documentation_url , target: :_blank
          end
          row :is_user_entry_point
          row :repository_url
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
              status_tag d.name, class: d.status
              text_node ""
            end
          end

          row 'External dependencies' do
            service.external_dependencies.map do |d|
              status_tag d.name, class: d.status
              text_node ""
            end
          end

          row 'Dependency of' do
            service.dependency_of.map do |d|
              status_tag d.name, class: d.status
              text_node ""
            end
          end

          row 'Resources' do
            service.external_resources.map do |d|
              status_tag d.name, class: :default
              text_node ""
            end
          end

        end
      end

    end
end
