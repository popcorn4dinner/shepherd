class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :health]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    network = NetworkBuilders::ProjectsNetworkBuilder.new(@projects).build()
    gon.networkData = network.to_hash
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    network = NetworkBuilders::ProjectNetworkBuilder.new(@project).build()
    gon.networkData = network.to_hash
  end

  def health
    network = NetworkBuilders::HealthNetworkBuilder.new(@project).build()
    gon.networkData = network.to_hash
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.fetch(:project, {})
    end
end
