class ServiceFileReader

  MANDATORY_FIELDS = [:name, :team, :project, :description, :health_endpoint]
  OPTIONAL_FIELDS = {external_resources: [], dependencies: [], smoke_tests: [], functional_tests: [], verifiers: [], documentation_url: nil, user_entry_point: false}
  VERIFIER_TYPES = {smoke_tests: :smoke_test, functional_tests: :functional_test}

  def self.from_git_repository(repo_url)
    raise ServiceConfigurationError, 'Http is not supported. Please use ssh url instead.' if is_incompatible repo_url

    folder = File.join(Settings.general.temp_directory, SecureRandom.uuid)

    git_clone repo_url, folder

    content = load_content_from folder, Settings.general.shepherd_file.name

    if is_valid(content)
      return complete content
    end
  end

  private

  def self.is_valid(content)
    MANDATORY_FIELDS.each do |field|
      unless content.include?(field)
        raise ServiceConfigurationError, "Field '#{field}' missing."
      end
    end

    return true
  end

  def self.complete(content)
    OPTIONAL_FIELDS.each do |field, default|
      adjust_verifiers_structure  content

      unless content.include?(field)
        content[field] = default
      end
    end

    return content
  end

  def self.adjust_verifiers_structure(content)
    verifiers = []

    content.each do |group, verifier_rows|
      verifier_rows.each do |verfifier_row|
        verfifier_row[:group] = group
        verifiers << verfifier_row
      end
    end

    return verifiers
  end

  def self.git_clone(url, folder)
    command = "git clone --no-checkout --depth 1 #{url} #{folder} && cd #{folder} && git checkout HEAD -- #{Settings.general.shepherd_file.name}"
    system command
  end

  def self.load_content_from(folder, file_name)
    begin
      YAML::load(File.open(File.join( folder, file_name))).deep_symbolize_keys!
    rescue
      {}
    end
  end

  private

  def self.is_incompatible(repo_url)
    repo_url.include? 'http'
  end

end
