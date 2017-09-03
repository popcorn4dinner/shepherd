class ServiceBuilder

  def add_name(name)
    service.name = name

    return self
  end

  def add_repository_url(url)
    service.repository_url = url

    return self
  end

  def add_team(team_name)
    team = Team.find_or_create_by(name: team_name)
    service.team = team

    return self
  end

  def add_project(project_name)
    project = Project.find_or_create_by(name: project_name)
    project.team = project.team || service.team

    service.project = project

    return self
  end

  def add_external_resource(resource_name)
    resource = ExternalResource.find_or_create_by(name: resource_name)

    service.external_resources << resource

    return self
  end

  def add_dependency(service_name)
    dependency = Service.find_by(:name service_name)


    return self
  end


  private

  def service
    @service || Service.new
  end

end
