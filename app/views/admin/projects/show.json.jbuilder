json.extract! @project, :id, :name, :slug, :created_at, :updated_at
json.team @project.team.name
json.services @project.services, :id, :name, :slug, :status, :health_endpoint
