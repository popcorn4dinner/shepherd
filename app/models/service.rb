class Service < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: [:slugged, :finders]

  validates :name, presence: true, uniqueness: true
  validates :health_endpoint, length: {maximum: 512}
  validates :repository_url, length: {maximum: 1024}
  validates :project, presence: true
  validates :description, presence: true

  belongs_to :project

  has_and_belongs_to_many :dependencies,
                            class_name: 'Service',
                            join_table: :dependencies,
                            foreign_key: :service_id,
                            association_foreign_key: :dependency_id,
                            uniq: true

  has_and_belongs_to_many :external_resources
  has_many :verifiers, inverse_of: :service, autosave: true

  def verify!
    verifiers.map do |verifier|
      { verifier.name => verifier.run }
    end
  end

  def verify_deep!
    dependencies.map {|d| {d.name => d.verify!} } << {name => verify!}
  end

  def documentation_url
    @documentation_url || repository_url.sub(':', '/').sub('git@', 'http://').sub('.git', '')
  end

  def internal_dependencies
    dependencies.select{|d| d.project == project}
  end

  def external_dependencies
    [direct_external_dependencies, implicit_dependencies].flatten
  end

  def direct_external_dependencies
    dependencies.select{|d| d.project != project}
  end

  def implicit_dependencies
    result = []
    external_resources.each do |resource|
      implicit_dependencies = resource.services.select{|s| s.project != project}
      result << implicit_dependencies
    end

    result.flatten.uniq
  end

  def dependency_of
    services = []
    Dependency.where(dependency_id: id).find_each do |dependency|
      services << dependency.service
    end

    services
  end

  def status
    if health_endpoint.present?
      case current_status_code
      when 200..299
        :up
      when 300..499
        :config_error
      else
        :down
      end
    else
      :no_status
    end
  end

  def health_endpoint_url
    service_url_resolver.resolve(health_endpoint)
  end

  private

  def current_status_code
    Rails.cache.fetch("#{name}.status", expires_in: 5.seconds) do
      begin
        response = RestClient.get health_endpoint_url
        return response.code
      rescue RestClient::Exception
        return 500
      rescue URI::InvalidURIError
        return 499
      end
    end
  end

  def service_url_resolver
    @@service_url_resolver ||= ServiceUrlResolver.new
  end


end
