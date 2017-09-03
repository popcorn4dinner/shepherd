class ServicesController < ApplicationController
  def new
    @service = Service.new
  end

  def create
    if @service.save
      redirect_to :root
    else
      render :action => 'new'
    end
  end

  private

  def service_params
    params.require(:service).permit(:repository_url)
  end
end
