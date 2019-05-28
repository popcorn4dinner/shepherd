# frozen_string_literal: true

class Service < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: %i[slugged finders]

  validates :name, presence: true, uniqueness: true
  validates :repository_url, length: { maximum: 1024 }
  validates :project, presence: true
  validates :description, presence: true

  belongs_to :project
  has_one :team, through: :project

  has_and_belongs_to_many :dependencies,
                          class_name: 'Service',
                          join_table: :dependencies,
                          foreign_key: :service_id,
                          association_foreign_key: :dependency_id,
                          uniq: true

  has_and_belongs_to_many :external_resources

  enum status: {up: 0, unknown: 1, warning: 2, down: 3}

  def internal_dependencies
    dependencies.select { |d| d.project == project }
  end

  def external_dependencies
    [direct_external_dependencies, implicit_dependencies].flatten
  end

  def direct_external_dependencies
    dependencies.reject { |d| d.project == project }
  end

  def implicit_dependencies
    result = []
    external_resources.each do |resource|
      implicit_dependencies = resource.services.reject { |s| s.project == project }
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

  def external_dependency_of
    dependency_of.reject { |d| d.project == project }
  end

  private

  def current_status_code
    Rails.cache.fetch("#{name}.status", expires_in: 20.seconds) do
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
