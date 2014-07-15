class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from Ohanakapa::UnprocessableEntity do |e|
    # Empty Organization name
    if e.to_s.include?("can't be blank for Organization")
      redirect_to request.referer,
        alert: "Organization name can't be blank!" and return

    # Missing phone number
    elsif e.to_s.include?("can't be blank for Phone")
      redirect_to request.referer,
        alert: "Number can't be blank for Phone" and return

    # Invalid Phone
    elsif e.to_s.include?("is not a valid US phone number")
      redirect_to request.referer,
        alert: "Please enter a valid US phone number" and return

    # Missing fax number
    elsif e.to_s.include?("can't be blank for Fax")
      redirect_to request.referer,
        alert: "Number can't be blank for Fax" and return

    # Invalid Fax
    elsif e.to_s.include?("is not a valid US fax number")
      redirect_to request.referer,
        alert: "Please enter a valid US fax number" and return

    # Invalid Accessibility
    elsif e.to_s.include?("Accessibility is invalid")
      redirect_to request.referer,
        alert: "This website is sending invalid values for accessibility
          options. Please contact the website owner." and return

    # Invalid admin email address
    elsif e.to_s.include?("admin_emails: [")
      redirect_to request.referer,
        alert: "Please enter a valid admin email address" and return

    # Missing both street and mailing address
    elsif e.to_s.include?("at least one address")
      redirect_to request.referer,
        alert: "Please enter at least one type of address" and return

    # Empty Street
    elsif e.to_s.include?("street: [\"can't be blank for Address\"]")
      redirect_to request.referer,
        alert: "Please enter a street" and return

    # Empty City
    elsif e.to_s.include?("city: [\"can't be blank for Address\"]")
      redirect_to request.referer,
        alert: "Please enter a city" and return

    # Empty State
    elsif e.to_s.include?("state: [\"can't be blank for Address\"")
      redirect_to request.referer,
        alert: "Please enter a state abbreviation" and return

    # Empty Zip
    elsif e.to_s.include?("zip: [\"can't be blank for Address\"")
      redirect_to request.referer,
        alert: "Please enter a ZIP code" and return

    # Empty Street
    elsif e.to_s.include?("street: [\"can't be blank for Mail Address\"")
      redirect_to request.referer,
        alert: "Please enter a street" and return

    # Empty City
    elsif e.to_s.include?("city: [\"can't be blank for Mail Address\"]")
      redirect_to request.referer,
        alert: "Please enter a city" and return

    # Empty State
    elsif e.to_s.include?("state: [\"can't be blank for Mail Address\"")
      redirect_to request.referer,
        alert: "Please enter a state abbreviation" and return

    # Empty Zip
    elsif e.to_s.include?("zip: [\"can't be blank for Mail Address\"")
      redirect_to request.referer,
        alert: "Please enter a ZIP code" and return

    # Invalid State
    elsif e.to_s.include?("valid 2-letter")
      redirect_to request.referer,
        alert: "Please enter a valid state abbreviation" and return

    # Invalid Zip
    elsif e.to_s.include?("is not a valid ZIP code")
      redirect_to request.referer,
        alert: "Please enter a valid ZIP code" and return

    # Contact name missing
    elsif e.to_s.include?("name: [\"can't be blank for Contact\"]")
      redirect_to request.referer,
        alert: "Please enter a contact name" and return

    # Contact title missing
    elsif e.to_s.include?("title: [\"can't be blank for Contact\"]")
      redirect_to request.referer,
        alert: "Please enter a contact title" and return

    # Location name missing
    elsif e.to_s.include?("name: [\"can't be blank for Location\"]")
      redirect_to request.referer,
        alert: "Location name can't be blank!" and return

    # Invalid email
    elsif e.to_s.include?("not a valid email")
      redirect_to request.referer,
        alert: "Please enter a valid email address" and return

    # Description missing
    elsif e.to_s.include?("description: [\"can't be blank for Location\"]")
      redirect_to request.referer,
        alert: "Please enter a description" and return

    # Invalid URL
    elsif e.to_s.include?("is not a valid URL")
      redirect_to request.referer,
        alert: "Please enter a valid URL" and return

    # Service Description missing
    elsif e.to_s.include?("Description can't be blank for Service")
      redirect_to request.referer,
        alert: "Please enter a Service description" and return

    # Service Name missing
    elsif e.to_s.include?("Name can't be blank for Service")
      redirect_to request.referer,
        alert: "Please enter a Service name" and return

    # Wrong format for service area
    elsif e.to_s.include?("improperly formatted")
      redirect_to request.referer,
        alert: "At least one service area is improperly formatted,
      or is not an accepted city or county name. Please make sure all
      words are capitalized." and return
    end
  end

  def days
    %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
  end

  def location_attributes
    {
      :accessibility           => params[:accessibility_options],
      :admin_emails            => admin_emails,
      :description             => params[:description],
      :emails                  => emails,
      :hours                   => params[:text_hours],
      :name                    => location_name,
      :short_desc              => params[:short_desc],
      :transportation          => params[:transportation],
      :urls                    => urls
    }
  end

  def service_attributes
    {
      :audience        => params[:audience],
      :description     => params[:service_description],
      :eligibility     => params[:eligibility],
      :fees            => params[:fees],
      :how_to_apply    => params[:how_to_apply],
      :keywords        => keywords,
      :name            => params[:service_name],
      :service_areas   => service_areas,
      :wait            => params[:wait]
    }
  end

  def address
    fields = [
      params[:street],
      params[:city],
      params[:state],
      params[:zip]
    ]
    return {} if fields.compact.empty? || fields.all?(&:empty?)
    {
      :new => params[:new_address],
      :destroy => params[:destroy_address],
      :street => params[:street],
      :city => params[:city],
      :state => params[:state],
      :zip => params[:zip]
    }
  end

  def admin_emails
    return nil unless params[:admin_emails].present?
    params[:admin_emails].reject(&:blank?)
  end

  def contacts
    contact_ids = params[:contact_ids] || []
    destroy = params[:destroy_contacts] || []

    names = params[:names] || []
    titles = params[:titles] || []
    phones = params[:contact_phones] || []
    extensions = params[:contact_phone_extensions] || []
    emails = params[:contact_emails] || []
    faxes = params[:contact_faxes] || []

    contacts = []
    (0..names.length - 1).each do |i|
      hash = {
        :contact_id => contact_ids[i],
        :destroy => destroy[i],
        :name => names[i],
        :title => titles[i],
        :phone => phones[i],
        :extension => extensions[i],
        :email => emails[i],
        :fax => faxes[i]
      }
      contacts.push(hash)
    end
    contacts.delete_if { |contact| contact.values.all? { |v| v.blank? } }
  end

  def emails
    return nil unless params[:emails].present?
    params[:emails].reject(&:blank?)
  end

  def faxes
    fax_ids = params[:fax_ids] || []
    destroy = params[:destroy_faxes] || []

    numbers = params[:fax_number] || []
    departments = params[:fax_department]

    faxes = []
    (0..numbers.length - 1).each do |i|
      hash = {
        :fax_id => fax_ids[i],
        :destroy => destroy[i],
        :number => numbers[i],
        :department => departments[i]
      }
      faxes.push(hash)
    end
    faxes.delete_if { |fax| fax.values.all? { |v| v.blank? } }
  end

  def keywords
    return nil unless params[:keywords].present?
    params[:keywords].reject(&:blank?)
  end

  def location_name
    params[:location_name]
  end

  def mail_address
    all_fields = [
      params[:attention],
      params[:m_street],
      params[:m_city],
      params[:m_state],
      params[:m_zip]
    ]
    if all_fields.compact.empty? || all_fields.all?(&:empty?)
      {}
    else
      {
        :new => params[:new_mail_address],
        :destroy => params[:destroy_mail_address],
        :attention => params[:attention],
        :street => params[:m_street],
        :city => params[:m_city],
        :state => params[:m_state],
        :zip => params[:m_zip]
      }
    end
  end

  def oe_ids
    return nil unless params[:oe_ids].present?
    params[:oe_ids]
  end

  def phones
    phone_ids = params[:phone_ids] || []
    destroy = params[:destroy_phones] || []

    numbers = params[:number] || []
    vanity_numbers = params[:vanity_number]
    departments = params[:department]
    extensions = params[:extension]

    phones = []
    (0..numbers.length - 1).each do |i|
      hash = {
        :phone_id => phone_ids[i],
        :destroy => destroy[i],
        :number => numbers[i],
        :vanity_number => vanity_numbers[i],
        :extension => extensions[i],
        :department => departments[i]
      }
      phones.push(hash)
    end
    phones.delete_if { |phone| phone.values.all? { |v| v.blank? } }
  end

  def service_areas
    return nil unless params[:service_areas].present?
    params[:service_areas].reject(&:blank?)
  end

  # def funding_sources
  #   fs = params[:funding_sources]
  #   if fs.present? && !fs.all?(&:empty?)
  #     params[:funding_sources]
  #   end
  # end

  def urls
    return nil unless params[:urls].present?
    params[:urls].reject(&:blank?)
  end

  def org_id
    params[:org_id]
  end

  def location_id
    params[:location_id]
  end

  def location_slug
    params[:location_slug]
  end

  def address_id
    params[:address_id]
  end

  def mail_address_id
    params[:mail_address_id]
  end

  def service_id
    params[:service_id]
  end

  def org_name
    params[:org_name]
  end

  def after_sign_in_path_for(resource)
    locations_path
  end
end
