class Service

  def self.from_shepherd_file(repository_url)

    config = ServiceFileReader::from_git_repository(repository_url)

    builder = ServiceBuilder.new

  end



end
