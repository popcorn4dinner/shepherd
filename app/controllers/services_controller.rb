class ServicesController < ApplicationController

  before_action :set_projects
  before_action :set_service, except: [:new, :create]

  skip_before_action :verify_authenticity_token

  def new
    @service = Service.new
  end

  def create
    begin
      @service = ServiceFactory::from_shepherd_file(service_params[:repository_url])

      if @service.save
        redirect_to :root
      else
        render :action => 'new'
      end
    rescue ServiceConfigurationError => e
      @service = Service.new
      @error = e.message
      render :action => 'new'
    end



  end

  def update
    @service = ServiceFactory::update_with_shepherd_file(@service)


    if @service.save
      respond_to do |format|
        format.json { render :show }
      end
    end

  end

  def verify
    render json: @service.verify_deep!
  end

  private

  def service_params
    params.require(:service).permit(:id, :repository_url)
  end

  def set_service
    @service = Service.friendly.find(params[:id])
  end

end
