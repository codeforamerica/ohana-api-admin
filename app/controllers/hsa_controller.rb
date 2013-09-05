class HsaController < ApplicationController

  def index
    @locations = Ohanakapa.locations(:page => params[:page], :per_page => 40)
  end

  def show
    @location = Ohanakapa.location(params[:id])
    @categories = Ohanakapa.cats
  end

  def edit_services
    keywords = [params[:keyword1], params[:keyword2], params[:keyword3], params[:keyword4]].delete_if {|k| k.empty?}
    id = params[:id]
    Ohanakapa.post("services/#{id}/keywords", :query => { :keywords => keywords })
    redirect_to request.env["HTTP_REFERER"]
  end
end