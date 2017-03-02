ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Recent Posts" do
            Project.last(5).map do |project|
              div class: "blank_slate_container" do
                h4 project.name
                ol do
                  li class: "action input_action" do
                    link_to("show", admin_project_path(project))
                  end
                  li class: "action input_action" do
                    link_to("administrate", admin_project_path(project))
                  end
                end
              end
            end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end

    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end


  end #content
end
