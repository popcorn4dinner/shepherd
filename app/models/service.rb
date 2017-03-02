class Service < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :health_endpoint, uniqueness: true
  validates :project, presence: true

  belongs_to :project

  has_and_belongs_to_many :dependencies,
                            class_name: 'Service',
                            join_table: :dependencies,
                            foreign_key: :service_id,
                            association_foreign_key: :dependency_id,
                            uniq: true

  has_and_belongs_to_many :external_resources


  def status
    unless health_endpoint.nil?
      status_map[retrieveStatusCode]
    else
      :no_status
    end
  end

  private

  def retrieveStatusCode
    #Rails.cache.fetch("#{name}.status", expires_in: 5.seconds) do
      begin
        response = Faraday.get health_endpoint
        puts "+++++++++++++++++++"
        puts response.status.to_i
        puts "+++++++++++++++++++"

        response.status
      rescue
        500
      end
    #end
  end

  def status_map
     {
    '202' => :up,
    '404' => :config_error,
    '500' => :down
  }
  end


end
