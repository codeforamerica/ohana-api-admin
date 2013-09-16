class HsaController < ApplicationController
  before_filter :authenticate_user!

  def index
    @locations = Ohanakapa.search("search",
      :exclude => "market_other", :page => params[:page], :per_page => 40)
  end

  def show
    @location = Ohanakapa.location(params[:id])
    unless @location.key?(:emails) && @location.emails.include?(current_user.email)
      redirect_to root_url,
        :alert => "Sorry, you don't have access to that page."
    end

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

    Ohanakapa.add_keywords_to_a_service(service_id, keywords) unless keywords.empty?
    Ohanakapa.replace_all_categories(service_id, cat_ids) if cat_ids
    Ohanakapa.update_location(location_id, :kind => kind) if kind

    redirect_to "#{root_url}?page=#{params[:page]}"
  end
end