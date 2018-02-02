# frozen_string_literal: true

class ServicesController < ApplicationController
  before_action :set_projects
  before_action :set_service, except: %i[new create]

  skip_before_action :verify_authenticity_token

  def new
    @service = Service.new
  end

  def create
    @service = ServiceFactory.from_shepherd_file(service_params[:repository_url])

    if @service.save
      redirect_to :root
    else
      render action: 'new'
    end
  rescue ServiceConfigurationError => e
    @service = Service.new
    @error = e.message
    render action: 'new'
  end

  def update
    @service = ServiceFactory.update_with_shepherd_file(@service)

    if @service.save
      respond_to do |format|
        format.json { render :show }
      end
    end
  end

  def verify
    results = @service.verify_deep!

    results.each do |target_name, verification_results|
      target_service = Service.find_by name: target_name

      notification = Notifications::ServiceVerification.new(target_service.team, @service.name, target_name, verification_results)

      notification.push

      SendVerificationResultNotificationJob.perform_later @service.name, target_name, verification_results.to_h
    end

    render json: results
  end

  private

  def service_params
    params.require(:service).permit(:id, :repository_url)
  end

  def set_service
    @service = Service.friendly.find(params[:id])
  end
end
