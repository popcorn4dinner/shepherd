json.extract! @service, :id, :name, :status,
                        :is_user_entry_point, :created_at, :updated_at
json.project @service.project.name
json.team @service.project.team.name
json.internal_dependencies @service.internal_dependencies, :id, :name, :status
json.external_dependencies @service.external_dependencies, :id, :name, :status
json.dependency_of @service.dependency_of, :id, :name, :status
