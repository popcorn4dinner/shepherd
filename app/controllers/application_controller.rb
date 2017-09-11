class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :set_projects


  private

  def set_projects
    @projects = Project.all
  end
end
