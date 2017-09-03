class ServiceFactory

  def self.from_shepherd_file(repository_url)

    config = ServiceFileReader::from_git_repository(repository_url)

    builder = ServiceBuilder.new

    builder
      .add_name(config[:name])
      .add_repository_url(repository_url)
      .add_team(config[:team])
      .add_project(config[:project])

    config[:external_resources].each do |resource|
      builder.add_external_resource(resource[:name])
    end

    config[:dependencies].each do |dependency|
      builder.add_external_resource(dependency[:name])
    end

    return builder.build
  end

end
