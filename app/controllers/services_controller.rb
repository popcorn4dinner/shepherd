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
      send_notifications(old_status, @service, service_params[:details])

      respond_to do |format|
        format.json { render :show }
      end
    end
  end

  private

  def service_params
    params.require(:service).permit(:id, :repository_url, :status, :details)
  end

  def set_service
    @service = Service.friendly.find(params[:id])
  end

  def send_notifications(old_status, service, details)
    if(started_failing(old_status, service))
      SendNotificationJob.perform_now service.team, service, service, Notifications::ServiceStatusAlert, details

      service.dependency_of.each do |consumer|
        SendNotificationJob.perform_now consumer.team, service, consumer, Notifications::ServiceDependencyWarning
      end
    end

    if(has_recovered(old_status, service))
      effected_teams_for(service).each do |team|
        SendNotificationJob.perform_now team, service, service, Notifications::ServiceRecovery
      end
    end
  end

  def has_recovered(old_status, service)
    old_status.to_sym == :down && service.status.to_sym == :up
  end

  def started_failing(old_status, service)
    old_status.to_sym == :up && service.status.to_sym ==:down
  end

  def effected_teams_for(service)
    [service, service.dependency_of].flatten.map(&:team).uniq
  end
 end
