module Features
  module SessionHelpers

    def sign_in(email, password)
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => email
        fill_in 'Password', :with => password
      end
      click_button 'Sign in'
    end

    def login_admin
      admin = FactoryGirl.create(:admin_user)
      login_as(admin, :scope => :user)
    end

    def login_user
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
    end

    def visit_locations
      visit("/locations")
    end

    def visit_test_location
      visit("/admin-test-location")
    end

    def visit_location_with_no_phone
      visit("/location-with-no-phone")
    end

    def add_phone_number
      click_link "Add a new number"
      fill_in "number[]", with: "7035551212"
      fill_in "vanity_number[]", with: "703555-ABCD"
      fill_in "extension[]", with: "x1223"
      fill_in "department[]", with: "CalFresh"
      click_button "Save changes"
    end

    def delete_phone_number
      click_link "Delete this number permanently"
      click_button "Save changes"
    end

    def add_contact
      click_link "Add a new contact"
      fill_in "names[]", with: "Moncef"
      fill_in "titles[]", with: "Director of Development"
      fill_in "contact_emails[]", with: "email@email.org"
      fill_in "contact_phones[]", with: "703-555-1212"
      fill_in "contact_faxes[]", with: "703-555-1234"
      click_button "Save changes"
    end

    def delete_contact
      click_link "Delete this contact permanently"
      click_button "Save changes"
    end

    def add_fax_number
      click_link "Add a new fax number"
      fill_in "fax_number[]", with: "2025551212"
      fill_in "fax_department[]", with: "CalFresh"
      click_button "Save changes"
    end

    def add_url
      click_link "Add a new website"
      fill_in "urls[]", with: "http://monfresh.com"
      click_button "Save changes"
    end

    def add_two_urls
      click_link "Add a new website"
      fill_in "urls[]", with: "http://ruby.com"
      click_link "Add a new website"
      urls = page.all(:xpath, "//input[@type='text' and @name='urls[]']")
      fill_in urls[-1][:id], with: "http://monfresh.com"
      click_button "Save changes"
    end

    # def delete_url
    #   click_link "Delete this website permanently"
    #   click_button "Save changes"
    # end

    def delete_all_urls
      delete_links = all("a", :text => "Delete this website permanently")
      delete_links.each do |a|
        click_link a[:text], match: :first
      end
      click_button "Save changes"
    end

    def add_service_area
      click_link "Add a new service area"
      fill_in "service_areas[]", with: "Belmont"
      click_button "Save changes"
    end

    def add_two_service_areas
      click_link "Add a new service area"
      fill_in "service_areas[]", with: "Belmont"
      click_link "Add a new service area"
      service_areas = page.all(:xpath, "//input[@type='text' and @name='service_areas[]']")
      fill_in service_areas[-1][:id], with: "East Palo Alto"
      click_button "Save changes"
    end

    def delete_all_service_areas
      delete_links = all("a", :text => "Delete this service area permanently")
      delete_links.each do |a|
        click_link a.text, match: :first
      end
      click_button "Save changes"
    end

    def add_two_keywords
      click_link "Add a new keyword"
      fill_in "keywords[]", with: "homeless"
      click_link "Add a new keyword"
      keywords = page.all(:xpath, "//input[@type='text' and @name='keywords[]']")
      fill_in keywords[-1][:id], with: "CalFresh"
      click_button "Save changes"
    end

    def delete_all_keywords
      delete_links = all("a", :text => "Delete this keyword permanently")
      delete_links.each do |a|
        click_link a.text, match: :first
      end
      click_button "Save changes"
    end

    def add_street_address
      fill_in "street", with: "modularity"
      fill_in "city", with: "utopia"
      fill_in "state", with: "XX"
      fill_in "zip", with: "12345"
      click_button "Save changes"
    end

    def remove_street_address
      fill_in "street", with: ""
      fill_in "city", with: ""
      fill_in "state", with: ""
      fill_in "zip", with: ""
      click_button "Save changes"
    end

    def add_mail_address
      fill_in "m_street", with: "modularity"
      fill_in "m_city", with: "utopia"
      fill_in "m_state", with: "XX"
      fill_in "m_zip", with: "12345"
      click_button "Save changes"
    end

    def remove_mail_address
      fill_in "m_street", with: ""
      fill_in "m_city", with: ""
      fill_in "m_state", with: ""
      fill_in "m_zip", with: ""
      click_button "Save changes"
    end

    def reset_accessibility
      within_fieldset("accessibility") do
        all('input[type=checkbox]').each do |checkbox|
          uncheck checkbox[:id]
        end
      end
      check "accessibility_restroom"
      click_button "Save changes"
    end

    def set_all_accessibility
      within_fieldset("accessibility") do
        all('input[type=checkbox]').each do |checkbox|
          check checkbox[:id]
        end
      end
      click_button "Save changes"
    end

    def reset_categories
      within("#categories") do
        uncheck "category_emergency"
        uncheck "category_food"
        uncheck "category_housing"
        uncheck "category_goods"
        uncheck "category_transit"
        uncheck "category_health"
        uncheck "category_money"
        uncheck "category_care"
        uncheck "category_education"
        uncheck "category_work"
        uncheck "category_legal"
      end
      click_button "Save changes"
    end

    def fill_in_all_required_fields
      fill_in "location_name", with: "new location with service fields"
      fill_in "description", with: "new description"
      fill_in "short_desc", with: "new short description"
      fill_in "street", with: "modularity"
      fill_in "city", with: "utopia"
      fill_in "state", with: "XX"
      fill_in "zip", with: "12345"
    end
  end
end