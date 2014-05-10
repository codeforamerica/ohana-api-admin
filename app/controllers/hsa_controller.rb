class HsaController < ApplicationController
  before_filter :authenticate_user!

  def index
    if admin?
      page = params[:page].present? ? params[:page] : 1
      per_page = params[:per_page].present? ? params[:per_page] : 30
      @locations = Ohanakapa.locations(page: page, per_page: per_page)
    else
      @locations = perform_search
      @org = @locations.first.organization if @locations.present?
    end
  end

  def show
    id = params[:id].split("/")[-1]
    begin
      @location = Ohanakapa.location(id)
      unless user_allowed_access_to_location?(@location) || admin?
        redirect_to root_url,
          :alert => "Sorry, you don't have access to that page."
      end
    rescue Ohanakapa::NotFound
      redirect_to "#{root_url}",
        alert: "Location not found! Please try another one." and return
    end
  end

  def new
    @locations = perform_search
    @org = @locations.first.organization if @locations.present?
    if @org.present?
      urls = []
      @org.rels[:locations].get.data.each do |loc|
        if loc.key?(:urls)
          urls.push(loc.urls)
        end
      end
      @location_url = urls.uniq.flatten.first
    else
      redirect_to locations_path,
        alert: "Sorry, you don't have access to that page." and return
    end
  end

  def edit_location
    if admin? || user_allowed_access_to_location?(Ohanakapa.location(location_id))
      # Update organization
      Ohanakapa.put("organizations/#{org_id}", :query => { :name => params[:org_name] })

      if address.present?
        # Update location address
        if address[:destroy] == "1"
          Ohanakapa.delete("locations/#{location_id}/address")

        elsif address[:new] == "1"
          Ohanakapa.post("locations/#{location_id}/address",
            :query => address.except(:address_id, :destroy))

        else
          Ohanakapa.patch("locations/#{location_id}/address",
            :query => address.except(:address_id, :destroy))
        end
      end

      if mail_address.present?
        # Update location mailing address
        if mail_address[:destroy] == "1"
          Ohanakapa.delete("locations/#{location_id}/mail_address")

        elsif mail_address[:new] == "1"
          Ohanakapa.post("locations/#{location_id}/mail_address",
            :query => mail_address.except(:new, :destroy))

        else
          Ohanakapa.patch("locations/#{location_id}/mail_address",
            :query => mail_address.except(:destroy, :new))
        end
      end

      # Update location
      Ohanakapa.update_location(location_id, location_attributes)

      # Update location contacts
      if contacts.present?
        contacts.each do |contact|
          if contact[:destroy] == "1"
            Ohanakapa.delete("locations/#{location_id}/contacts/#{contact[:contact_id]}")
          elsif contact[:contact_id].blank?
            Ohanakapa.post("locations/#{location_id}/contacts",
              :query => contact.except(:contact_id, :destroy))
          elsif contact[:contact_id].present?
            Ohanakapa.patch("locations/#{location_id}/contacts/#{contact[:contact_id]}",
              :query => contact.except(:contact_id, :destroy))
          end
        end
      end

      # Update location faxes
      if faxes.present?
        faxes.each do |fax|
          if fax[:destroy] == "1"
            Ohanakapa.delete("locations/#{location_id}/faxes/#{fax[:fax_id]}")
          elsif fax[:fax_id].blank?
            Ohanakapa.post("locations/#{location_id}/faxes",
              :query => fax.except(:fax_id, :destroy))
          elsif fax[:fax_id].present?
            Ohanakapa.patch("locations/#{location_id}/faxes/#{fax[:fax_id]}",
              :query => fax.except(:fax_id, :destroy))
          end
        end
      end

      # Update location phones
      if phones.present?
        phones.each do |phone|
          if phone[:destroy] == "1"
            Ohanakapa.delete("locations/#{location_id}/phones/#{phone[:phone_id]}")
          elsif phone[:phone_id].blank?
            Ohanakapa.post("locations/#{location_id}/phones",
              :query => phone.except(:phone_id, :destroy))
          elsif phone[:phone_id].present?
            Ohanakapa.patch("locations/#{location_id}/phones/#{phone[:phone_id]}",
              :query => phone.except(:phone_id, :destroy))
          end
        end
      end

      # Update service
      Ohanakapa.put("services/#{service_id}", :query => service_attributes)

      # Update service categories
      Ohanakapa.put("services/#{service_id}/categories", :query =>
        {
          :category_slugs => params[:category_slugs]
        }
      )

      redirect_to location_path(location_id), notice: "Changes for #{location_name} successfully saved!" and return
    else
      redirect_to locations_path,
        alert: "Sorry, you don't have access to that page." and return
    end
  end

  def create_location
    Ohanakapa.post("locations/", query: location_attributes.
      merge(
        organization_id: org_id,
        address_attributes: address,
        mail_address_attributes: mail_address,
        contacts_attributes: contacts,
        faxes_attributes: faxes,
        phones_attributes: phones
      )
    )

    unless Ohanakapa.last_response.data.is_a?(Array)
      location_id = Ohanakapa.last_response.data.id
    end

    if current_user_has_generic_email?
      Ohanakapa.update_location(location_id, { admin_emails: [current_user.email] })
    end

    Ohanakapa.post("locations/#{location_id}/services",
      query: service_attributes)

    unless Ohanakapa.last_response.data.blank?
      service_id = Ohanakapa.last_response.data.id
    end

    if service_id.present?
      Ohanakapa.put("services/#{service_id}/categories", :query =>
        {
          :category_slugs => params[:category_slugs]
        }
      )
    end

    if location_id.present?
      redirect_to location_path(location_id),
        notice: "New location \"#{location_name}\" for #{org_name} successfully "+
          "created! If you haven't already, please continue filling out as many "+
          "fields as possible." and return
    end
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

  def user_allowed_access_to_location?(location)
    if current_user_has_generic_email?
      emails_match_user_email?(location) || admins_match_user_email?(location)
    else
      emails_match_domain?(location) || urls_match_domain?(location)
    end
  end

  def urls_match_domain?(location)
    if location.key?(:urls)
      location.urls.select { |url| url.include?(domain) }.length > 0
    end
  end

  def emails_match_domain?(location)
    if location.key?(:emails)
      location.emails.select { |email| email.include?(domain) }.length > 0
    end
  end

  def emails_match_user_email?(location)
    if location.key?(:emails)
      location.emails.select { |email| email == current_user.email }.length > 0
    end
  end

  def admins_match_user_email?(location)
    if location.key?(:admin_emails)
      location.admin_emails.select { |email| email == current_user.email }.length > 0
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