class ServiceFileReader

  MANDATORY_FIELDS = [:name, :team, :project]
  OPTIONAL_FIELDS = [:external_resources, :dependencies, :smoke_tests, :functional_tests]

  def self.from_git_repository(repo_url)

    folder = File.join(Settings.general.temp_directory, SecureRandom.uuid)

    git_clone repo_url, folder

    content = load_content_from folder, Settings.general.shepherd_file.name

    if( is_valid(content) )
      return complete content
    end
  end

  private

  def self.is_valid(content)
    MANDATORY_FIELDS.each do |field|
      unless content.include?(field)
        raise "Field '#{field}' missing."
      end
    end

    return true
  end

  def self.complete(content)
    OPTIONAL_FIELDS.each do |field|
      unless content.include?(field)
        content[field] = []
      end
    end

    return content
  end

  def self.git_clone(url, folder)
    command = "git clone --no-checkout --depth 1 #{url} #{folder} && cd #{folder} && git checkout HEAD -- #{Settings.general.shepherd_file.name}"
    system command
  end

  def self.load_content_from(folder, file_name)
    YAML::load(File.open(File.join( folder, file_name))).deep_symbolize_keys!

  end

end
