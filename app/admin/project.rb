ActiveAdmin.register Project do

permit_params :name, :team_id

action_item :dashboard, only: :index do
  link_to "Open Dashboard", projects_path
end

action_item :dashboard, only: :show do
  link_to "Open Dashboard", project_path(project)
end

index do
  column :name
  column :team
  column :dashboard do |project|
    link_to :open, project_path(project)
  end
  actions
end

show do
    panel "Project Details" do
      attributes_table_for project do
        row :name
        row :team
      end
    end

    panel "Services" do
      attributes_table_for project do
        project.services.each do |service|
          row service.name do
            status_tag service.status
            text_node "&nbsp;".html_safe
            link_to :show, admin_service_path(service)
          end
        end
      end
    end
  end

end
