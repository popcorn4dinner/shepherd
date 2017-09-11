class ServicesController < ApplicationController

  before_action :set_projects

  def new
    @service = Service.new

  end

  def create

    @service = ServiceFactory::from_shepherd_file(service_params[:repository_url])

    if @service.save
      redirect_to :root
    else
      render :action => 'new'
    end
  end

  def update
    @service = Service.friendly.find(params[:id])

    @service = ServiceFactory::update_with_shepherd_file(@service)


    if @service.save

    else

    end

  end

  private

  def service_params
    params.require(:service).permit(:id, :repository_url)
  end

  def service
    @service || Service.find(slug: params[:id])
  end
end
