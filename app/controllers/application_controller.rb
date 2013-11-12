class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def days
    %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
  end

  def address
    non_state_fields = [params[:street], params[:city], params[:zip]]

    unless non_state_fields.all?(&:empty?)
      {
        :street => params[:street],
        :city => params[:city],
        :state => params[:state],
        :zip => params[:zip]
      }
    end
  end

  def contacts
    names = params[:names]
    titles = params[:titles]
    phones = params[:contact_phones]
    extensions = params[:contact_phone_extensions]
    emails = params[:contact_emails]
    faxes = params[:contact_faxes]

    if names.present?
      contacts = []
      (0..names.length).each do |i|
        hash = {
          :name => names[i],
          :title => titles[i],
          :phone => phones[i],
          :extension => extensions[i],
          :email => emails[i],
          :fax => faxes[i]
        }.reject { |_,v| v.blank? }
        contacts.push(hash)
      end
    end
    contacts
  end

  def mail_address
    all_fields = [params[:attention], params[:m_street], params[:m_city], params[:m_state], params[:m_zip]]
    unless all_fields.all?(&:empty?)
      {
        :attention => params[:attention],
        :street => params[:m_street],
        :city => params[:m_city],
        :state => params[:m_state],
        :zip => params[:m_zip]
      }
    end
  end

  def phones
    numbers = params[:number]
    vanity_numbers = params[:vanity_number]
    departments = params[:department]
    extensions = params[:extension]
    hours = params[:hours]

    if numbers.present?
      phones = []
      (0..numbers.length).each do |i|
        hash = {
          :number => numbers[i],
          :vanity_number => vanity_numbers[i],
          :extension => extensions[i],
          :department => departments[i],
          :hours => hours[i]
        }.reject { |_,v| v.blank? }
        phones.push(hash)
      end
    end
    phones
  end

  def faxes
    numbers = params[:fax_number]
    departments = params[:fax_department]

    if numbers.present?
      faxes = []
      (0..numbers.length).each do |i|
        hash = {
          :number => numbers[i],
          :department => departments[i],
        }.reject { |_,v| v.blank? }
        faxes.push(hash)
      end
    end
    faxes
  end

  def service_areas
    service_areas = params[:service_areas]
    if service_areas.present? && !service_areas.all?(&:empty?)
      params[:service_areas]
    end
  end

  def funding_sources
    fs = params[:funding_sources]
    if fs.present? && !fs.all?(&:empty?)
      params[:funding_sources]
    end
  end

  def keywords
    k = params[:keywords]
    if k.present? && !k.all?(&:empty?)
      params[:keywords]
    end
  end

  def schedule
    # schedule = []
    # days.each_with_index do |day, i|
    #   # h.merge!({ day.downcase.to_sym =>
    #   #   [
    #   #     { :open => params["#{day}_first_open"], :close => params["#{day}_first_close"] },
    #   #     { :open => params["#{day}_sec_open"], :close => params["#{day}_sec_close"] }
    #   #   ]
    #   # })
    #   if params["#{day}_sec_open"].present?
    #     schedule.push(
    #       { :open => params["#{day}_first_open"],
    #         :close => params["#{day}_first_close"],
    #         :day => i.to_i
    #       },
    #       { :open => params["#{day}_sec_open"],
    #         :close => params["#{day}_sec_close"],
    #         :day => i.to_i
    #       }
    #     )
    #   else
    #     schedule.push(
    #       { :open => params["#{day}_first_open"],
    #         :close => params["#{day}_first_close"],
    #         :day => i.to_i
    #       },
    #       { :open => params["#{day}_sec_open"],
    #         :close => params["#{day}_sec_close"],
    #         :day => i.to_i
    #       }
    #     )
    #   end
    # end
  end
end
