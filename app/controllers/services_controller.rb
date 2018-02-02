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
    @verification_results = @service.verify_deep!

    @verification_results.each do |target_name, results|
      send_notification_for @service.name, target_name, results
    end

    render json: @verification_results
  end

  private

  def service_params
    params.require(:service).permit(:id, :repository_url)
  end

  def set_service
    @service = Service.friendly.find(params[:id])
  end

  def send_notification_for(trigger, target, results)
    SendVerificationResultNotificationJob.perform_later trigger, target, results.map(&:to_h)
  end
end
