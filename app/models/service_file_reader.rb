class ServiceFileReader

  require 'open3'

  DEFAULT_BRANCH = 'master'
  MANDATORY_FIELDS = [:name, :team, :project, :description]
  OPTIONAL_FIELDS = {external_resources: [], dependencies: [], documentation_url: nil, user_entry_point: false}

  def self.from_git_repository(repo_url)
    raise ServiceConfigurationError, 'SSH is not supported. Please use https url instead.' if is_incompatible repo_url


    folder = File.join(Settings.general.temp_directory, SecureRandom.uuid)

    git_clone repo_url, folder, Settings.general.git_branch

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
      unless content.include?(field)
        content[field] = default
      end
    end

    return content
  end

  def self.git_clone(url, folder, branch)
    stdout, stderr, status = Open3.capture3 clone_command_for url, folder, branch

    unless status.cuccess?
      puts "First clone failed. Cloning from #{DEFAULT_BRANCH} instead."
      stdout, stderr, status = Open3.capture3 clone_command_for url, folder, DEFAULT_BRANCH
    end

    status.success?
  end

  def self.clone_command_for(url, folder, branch)
    "git clone --no-checkout --branch #{branch}--depth 1 #{auth_url_for(url)} #{folder} && cd #{folder} && git checkout HEAD -- #{Settings.general.shepherd_file.name}"
  end

  def self.load_content_from(folder, file_name)
    begin
      YAML::load(File.open(File.join( folder, file_name))).deep_symbolize_keys!
    rescue
      raise ServiceConfigurationError,
            "Unable to read service configuration file. Check the following file #{File.join( folder, file_name)}."
    end
  end

  private

  def self.auth_url_for(url)
    url.gsub('://', "://#{Settings.git.user}:#{Settings.git.access_token}")
  end

  def self.is_incompatible(repo_url)
    repo_url.start_with? 'git@'
  end

end
