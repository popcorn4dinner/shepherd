class ServiceBuilder

  def initialize(service = Service.new)
    @service = service

  end

  def add_name(name)
    service.name = name

    self
  end

  def add_description(description)
    service.description = description

    self
  end

  def add_repository_url(url)
    service.repository_url = url

    self
  end

  def add_user_entry_point(value)
    service.is_user_entry_point = value

    self
  end

  def add_documentation_url(url)
    service.documentation_url = url.empty? ? nil : url

    self
  end

  def add_team(team_name)
    @team = Team.find_or_create_by(name: team_name)

    self
  end

  def add_project(project_name)
    project = Project.find_or_create_by(name: project_name)
    project.team = project.team || @team
    project.save

    service.project = project

    self
  end

  def add_external_resource(resource_name)
    resource = ExternalResource.find_or_create_by(name: resource_name)

    service.external_resources << resource
    self
  end

  def replace_external_resources_with(records)
    service.external_resources = []
    records.each do |record|
      add_external_resource record
    end

    self
  end

  def add_dependency(service_name)
    dependency = Service.find_by(name: service_name)
    unless dependency.nil?
      service.dependencies << dependency
    end

    self
  end

  def replace_dependencies_with(records)
    service.dependencies.delete_all unless service.new_record?
    records.each do |record|
      add_dependency record
    end

    self
  end

  def add_verifier(name, group, runner, runner_params = {})

    verifier = Verifier.create(
        name: name,
        group: group,
        runner_name: runner,
        runner_params_attributes: runner_params.to_a.map{ |e| {name: e.first, value: e.last} }
    )

    service.verifiers << verifier
    self
  end

  def replace_verifiers_with(records)
    service.verifiers.delete_all unless service.new_record?

    records.each do |record|
      add_verifier record[:name], record[:group], record[:runner], record[:runner_params]
    end

    self
  end

  def build
    @service
  end

  private

  def service
    @service || Service.new
  end

end
