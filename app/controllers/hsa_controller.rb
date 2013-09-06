require 'json'

class HsaController < ApplicationController

  def index
    @locations = Ohanakapa.locations(:page => params[:page], :per_page => 40)
  end

  def show
    @location = Ohanakapa.location(params[:id])

    # expires_in 3.minutes, :public => true

    # # etag based on @location object
    # # Rendering is not executed if etag is the same
    # if stale?(@location)
    #   respond_to do |format|
    #     format.html # show.html.haml
    #   end
    # end

  end

  def edit_services
    keywords = [params[:keyword1], params[:keyword2], params[:keyword3], params[:keyword4]].delete_if {|k| k.empty?}
    kind = params[:kind]
    cat_ids = params[:category_ids]
    service_id = params[:service_id]
    location_id = params[:location_id]

    Ohanakapa.post("services/#{service_id}/keywords", :query => { :keywords => keywords }) unless keywords.empty?
    Ohanakapa.put("services/#{service_id}/categories", :query => { :category_ids => cat_ids }) if cat_ids
    Ohanakapa.put("locations/#{location_id}", :query => { :kind => kind }) if kind

    redirect_to "#{root_url}?page=#{params[:page]}"
  end
end