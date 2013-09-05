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
    cat_ids = params[:category_ids]

    Ohanakapa.post("services/#{id}/keywords", :query => { :keywords => keywords }) unless keywords.empty?
    Ohanakapa.put("services/#{id}/categories", :query => { :category_ids => cat_ids }) if cat_ids

    redirect_to "#{root_url}?page=#{params[:page]}"
  end
end