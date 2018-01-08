class ServiceFactory

  def self.from_shepherd_file(repository_url)

    config = ServiceFileReader::from_git_repository(repository_url)

    service = build_service_with config, ServiceBuilder.new
    service.repository_url = repository_url

    return  service
  end

  def self.update_with_shepherd_file(service)
    config = ServiceFileReader::from_git_repository(service.repository_url)

    return self.build_service_with config, ServiceBuilder.new(service)
  end

  private

  def self.build_service_with(config, service_builder)
    service_builder
        .add_name(config[:name])
        .add_description(config[:description])
        .add_team(config[:team])
        .add_user_entry_point(config[:user_entry_point])
        .add_project(config[:project])
        .add_health_endpoint(config[:health_endpoint])
        .replace_external_resources_with(config[:external_resources])
        .replace_dependencies_with(config[:dependencies])
        .replace_verifiers_with(config[:verifiers])
        .build
  end

end
