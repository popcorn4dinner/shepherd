# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_projects
  before_action :set_project, only: %i[show health incidents]

  # GET /projects
  # GET /projects.json
  def index
    network = NetworkBuilders::ProjectsNetworkBuilder.new(@projects).build
    gon.networkData = network.to_hash
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    network = NetworkBuilders::ProjectNetworkBuilder.new(@project).build
    gon.networkData = network.to_hash
  end

  def health
    network = NetworkBuilders::HealthNetworkBuilder.new(@project).build
    gon.networkData = network.to_hash

    respond_to do |format|
      format.html { render :health }
      format.json { render json: network.to_hash }
    end
  end

  def incidents
    @alerts = @project.services.where(status: :up)
    @warnings = @project.services.each(&:direct_external_dependencies).select { |s| s.down? }

    response_body = {
      alerts: @alerts,
      warnings: @warnings
    }

    respond_to do |format|
      format.html { render :index, @alerts }
      format.json { render json: response_body.to_json }
    end
  end

  private

  def set_project
    @project = Project.find_by(slug: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.fetch(:project, {})
  end
end
