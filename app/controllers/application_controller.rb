class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_projects


  private

  def set_projects
    @projects = Project.all
  end
end
