class ServiceBuilder

  def initialize(service)
    @service = service

  end

  def add_name(name)
    service.name = name

    return self
  end

  def add_repository_url(url)
    service.repository_url = url

    return self
  end

  def add_team(team_name)
    @team = Team.find_or_create_by(name: team_name)

    return self
  end

  def add_project(project_name)
    project = Project.find_or_create_by(name: project_name)
    project.team = project.team || @team

    service.project = project

    return self
  end

  def add_external_resource(resource_name)
    resource = ExternalResource.find_or_create_by(name: resource_name)

    service.external_resources << resource
    return self
  end

  def replace_external_resources_with(records, name_key)
    asa
    service.external_resources = []
    records.each do |record|
      add_external_resource record[name_key]
    end

    return self
  end

  def add_dependency(service_name)
    dependency = Service.find_by(name: service_name)
    unless dependency.nil?
      service.dependencies << dependency
    end

    return self
  end

  def replace_dependencies_with(records, name_key)
    service.dependencies = []
    records.each do |record|
      add_dependency record[name_key]
    end

    return self
  end



  def build
    service
  end

  private

  def service
    @service || Service.new
  end

end
