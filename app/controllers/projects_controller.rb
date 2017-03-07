class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    network_for gon, @projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # network_for gon, @project
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.fetch(:project, {})
    end

    def network_for(gon, resource)
      gon.network_data = Network.new(resource).to_hash
    end
end
