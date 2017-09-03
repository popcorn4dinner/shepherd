class ServiceFileReader

  mandatory_fields: [:name, :team, :project]
  optional_fields: [:resources, :dependencies, :smoke_tests, :functional_tests]

  def self.from_git_repository(repo_url)

    folder_name = File.join(Settings.general.temp_directory, SecureRandom.uuid)

    system "git clone --no-checkout --depth 1 #{repo_url} #{folder_name} && cd #{folder_name} && git show HEAD:#{Settings.general.shepherd_file.name}"

    if $?.exitstatus == 0
      raise "Couldn't clone service repository."
    end

    content = YAML::load(File.open(File.join( folder_name, Settings.general.shepherd_file.name)

    if( is_valid(content) )
      return complete content
    end
  end

  private

  def is_valid(content)
    mandatory_fields.each do |field|
      unless content.include?(field)
        raise ServiceCreationError.new "Field '#{field}' missing."
      end
    end

    return true
  end

  def complete(content)
    mandatory_fields.each do |field|
      unless content.include?(field)
        content[field] = []
      end
    end

    return content
  end

end
