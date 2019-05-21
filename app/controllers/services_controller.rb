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

  def refresh
    @service = ServiceFactory.update_with_shepherd_file(@service)

    if @service.save
      respond_to do |format|
        format.json { render :show }
      end
    end
  end

  def update_status
    old_status = @service.status
    @service.send("#{service_params[:status]}!")

    if @service.save
      send_notification(old_status, @service.status)
      respond_to do |format|
        format.json { render :show }
      end
    end
  end

  private

  def service_params
    params.require(:service).permit(:id, :repository_url, :status)
  end

  def set_service
    @service = Service.friendly.find(params[:id])
  end

  def send_notification(old_status, new_status)
    SendVerificationResultNotificationJob.perform_later @service, old_status, new_status
  end
end
