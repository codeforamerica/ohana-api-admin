class HsaController < ApplicationController
  before_filter :authenticate_user!

  #before_filter :days

  def index
    if admin?
      page = params[:page].present? ? params[:page] : 1
      @locations = Ohanakapa.locations(page: page)
    else
      @locations = perform_search
      @org = @locations.first.organization if @locations.present?
    end
  end

  def show
    id = params[:id].split("/")[-1]
    begin
      @location = Ohanakapa.location(id)
      unless location_domain_matches_user_domain?(@location) || admin?
        redirect_to root_url,
          :alert => "Sorry, you don't have access to that page."
      end
    rescue Ohanakapa::NotFound
      redirect_to "#{root_url}",
        alert: "Location not found! Please try another one." and return
    end

    #@days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

    # expires_in 3.minutes, :public => true

    # # etag based on @location object
    # # Rendering is not executed if etag is the same
    # if stale?(@location)
    #   respond_to do |format|
    #     format.html # show.html.haml
    #   end
    # end

  end

  def new
    @locations = perform_search
    @org = @locations.first.organization
    urls = []
    @org.rels[:locations].get.data.each do |loc|
      if loc.key?(:urls)
        urls.push(loc.urls)
      end
    end
    @location_url = urls.uniq.flatten.first
  end

  def edit_services
    service_id = params[:service_id]
    location_id = params[:location_id]

    begin
      Ohanakapa.put("organizations/#{org_id}/", :query => { :name => params[:org_name] })
    rescue Ohanakapa::BadRequest => e
      if e.to_s.include?("Name can't be blank")
        redirect_to request.referer,
          alert: "Organization name can't be blank!" and return
      end
    end

    begin
      Ohanakapa.update_location(location_id, location_attributes)
    rescue Ohanakapa::BadRequest => e
      # Invalid Phone
      if e.to_s.include?("a valid US phone number")
        redirect_to request.referer,
          alert: "Please enter a valid US phone number" and return

      # Invalid Fax
      elsif e.to_s.include?("a valid US fax number")
        redirect_to request.referer,
          alert: "Please enter a valid US fax number" and return

      # Invalid Accessibility
      elsif e.to_s.include?("Accessibility is invalid")
        redirect_to request.referer,
          alert: "This website is sending invalid values for accessibility
            options. Please contact the website owner." and return

      # Missing both street and mailing address
      elsif e.to_s.include?("at least one address")
        redirect_to request.referer,
          alert: "Please enter at least one type of address" and return

      # Empty Street
      elsif e.to_s.include?("Street can't be blank")
        redirect_to request.referer,
          alert: "Please enter a street" and return

      # Empty City
      elsif e.to_s.include?("City can't be blank")
        redirect_to request.referer,
          alert: "Please enter a city" and return

      # Empty State
      elsif e.to_s.include?("State can't be blank")
        redirect_to request.referer,
          alert: "Please enter a state abbreviation" and return

      # Empty Zip
      elsif e.to_s.include?("Zip can't be blank")
        redirect_to request.referer,
          alert: "Please enter a ZIP code" and return

      # Invalid State
      elsif e.to_s.include?("State is too short")
        redirect_to request.referer,
          alert: "Please enter a valid state abbreviation" and return

      # Invalid Zip
      elsif e.to_s.include?("is not a valid ZIP code")
        redirect_to request.referer,
          alert: "Please enter a valid ZIP code" and return

      # Contact name missing
      elsif e.to_s.include?("Name can't be blank for Contact")
        redirect_to request.referer,
          alert: "Please enter a contact name" and return

      # Contact title missing
      elsif e.to_s.include?("Title can't be blank for Contact")
        redirect_to request.referer,
          alert: "Please enter a contact title" and return

      # Location name missing
      elsif e.to_s.include?("Name can't be blank")
        redirect_to request.referer,
          alert: "Location name can't be blank!" and return

      # Invalid email
      elsif e.to_s.include?("not a valid email")
        redirect_to request.referer,
          alert: "Please enter a valid email address" and return

      # Description missing
      elsif e.to_s.include?("Description can't be blank")
        redirect_to request.referer,
          alert: "Please enter a description" and return

      # Short description missing
      elsif e.to_s.include?("Short desc can't be blank")
        redirect_to request.referer,
          alert: "Please enter a short description" and return

      # Invalid URL
      elsif e.to_s.include?("is not a valid URL")
        redirect_to request.referer,
          alert: "Please enter a valid URL" and return

      # Kind missing
      elsif e.to_s.include?("Kind can't be blank")
        redirect_to request.referer,
          alert: "Please select a Kind" and return
      end
    end

    begin
      Ohanakapa.put("services/#{service_id}/", :query => service_attributes)
    rescue Ohanakapa::BadRequest => e
      # Wrong format for service area
      if e.to_s.include?("improperly formatted")
        redirect_to request.referer,
          alert: "At least one service area is improperly formatted,
        or is not an accepted city or county name. Please make sure all
        words are capitalized." and return
      end
    end

    #Ohanakapa.put("locations/#{location_id}/schedule", :query => { :schedule => schedule }) if schedule

    Ohanakapa.put("services/#{service_id}/categories", :query =>
      {
        :category_slugs => params[:category_slugs]
      }
    )

    redirect_to locations_path, notice: "Changes for <a href='#{location_id}'>#{location_name}</a> successfully saved!".html_safe and return
  end

  def create_location
    begin
      Ohanakapa.post("locations/",
        query: location_attributes.merge(organization_id: org_id))
    rescue Ohanakapa::BadRequest => e
      # Invalid Phone
      if e.to_s.include?("a valid US phone number")
        redirect_to request.referer,
          alert: "Please enter a valid US phone number" and return

      # Invalid Fax
      elsif e.to_s.include?("a valid US fax number")
        redirect_to request.referer,
          alert: "Please enter a valid US fax number" and return

      # Invalid Accessibility
      elsif e.to_s.include?("Accessibility is invalid")
        redirect_to request.referer,
          alert: "This website is sending invalid values for accessibility
            options. Please contact the website owner." and return

      # Missing both street and mailing address
      elsif e.to_s.include?("at least one address")
        redirect_to request.referer,
          alert: "Please enter at least one type of address" and return

      # Empty Street
      elsif e.to_s.include?("Street can't be blank")
        redirect_to request.referer,
          alert: "Please enter a street" and return

      # Empty City
      elsif e.to_s.include?("City can't be blank")
        redirect_to request.referer,
          alert: "Please enter a city" and return

      # Empty State
      elsif e.to_s.include?("State can't be blank")
        redirect_to request.referer,
          alert: "Please enter a state abbreviation" and return

      # Empty Zip
      elsif e.to_s.include?("Zip can't be blank")
        redirect_to request.referer,
          alert: "Please enter a ZIP code" and return

      # Invalid State
      elsif e.to_s.include?("State is too short")
        redirect_to request.referer,
          alert: "Please enter a valid state abbreviation" and return

      # Invalid Zip
      elsif e.to_s.include?("is not a valid ZIP code")
        redirect_to request.referer,
          alert: "Please enter a valid ZIP code" and return

      # Contact name missing
      elsif e.to_s.include?("Name can't be blank for Contact")
        redirect_to request.referer,
          alert: "Please enter a contact name" and return

      # Contact title missing
      elsif e.to_s.include?("Title can't be blank for Contact")
        redirect_to request.referer,
          alert: "Please enter a contact title" and return

      # Location name missing
      elsif e.to_s.include?("Name can't be blank")
        redirect_to request.referer,
          alert: "Location name can't be blank!" and return

      # Invalid email
      elsif e.to_s.include?("not a valid email")
        redirect_to request.referer,
          alert: "Please enter a valid email address" and return

      # Description missing
      elsif e.to_s.include?("Description can't be blank")
        redirect_to request.referer,
          alert: "Please enter a description" and return

      # Short description missing
      elsif e.to_s.include?("Short desc can't be blank")
        redirect_to request.referer,
          alert: "Please enter a short description" and return

      # Invalid URL
      elsif e.to_s.include?("is not a valid URL")
        redirect_to request.referer,
          alert: "Please enter a valid URL" and return

      # Kind missing
      elsif e.to_s.include?("Kind can't be blank")
        redirect_to request.referer,
          alert: "Please select a Kind" and return
      end
    end

    location_id = Ohanakapa.last_response.data.id

    begin
      Ohanakapa.post("locations/#{location_id}/services/",
        query: service_attributes)
    rescue Ohanakapa::BadRequest => e
      # Wrong format for service area
      if e.to_s.include?("improperly formatted")
        redirect_to request.referer,
          alert: "At least one service area is improperly formatted,
        or is not an accepted city or county name. Please make sure all
        words are capitalized." and return
      end
    end

    service_id = Ohanakapa.last_response.data._id

    Ohanakapa.put("services/#{service_id}/categories", :query =>
      {
        :category_slugs => params[:category_slugs]
      }
    )

    redirect_to locations_path,
      notice: "New location \"#{location_name}\" for #{org_name} successfully "+
        "created! Refresh this page to see your new location." and return
  end

  def domain
    current_user.email.split("@").last
  end

  def delete_location
    location_id = params[:location_id]
    location_name = params[:loc_name]
    org_name = params[:org_name]

    Ohanakapa.delete("locations/#{location_id}")
    redirect_to locations_path,
      notice: "Location \"#{location_name}\" for #{org_name} successfully "+
        "deleted! Refresh the page to see the changes." and return
  end

  def confirm_delete_location
    @loc_name = params[:loc_name]
    @org_name = params[:org_name]
    @location_id =  params[:location_id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def admin?
    current_user.role == "admin"
  end

  def location_domain_matches_user_domain?(location)
    if location.key?(:emails)
      emails = location.emails.select { |email| email.include?(domain) }
      exact_match = location.emails.select { |email| email == current_user.email }
    end

    if location.key?(:urls)
      urls = location.urls.select { |url| url.include?(domain) }
    end

    if current_user_has_generic_email?
      exact_match.present?
    else
      emails.present? || urls.present?
    end
  end

  def current_user_has_generic_email?
    generic_domains = %w(gmail.com hotmail.com aol.com yahoo.com sbcglobal.net co.sanmateo.ca.us smcgov.org)
    generic_domains.include?(domain)
  end

  def perform_search
    if current_user_has_generic_email?
      Ohanakapa.search("search", :email => current_user.email)
    else
      Ohanakapa.search("search", :domain => domain)
    end
  end

end