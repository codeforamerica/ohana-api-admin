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

    def login_user(user)
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
      click_link "Add a phone number"
      fill_in "number[]", with: "7035551212"
      fill_in "vanity_number[]", with: "703555-ABCD"
      fill_in "extension[]", with: "x1223"
      fill_in "department[]", with: "CalFresh"
    end

    def delete_phone_number
      click_link "Delete this number permanently"
      click_button "Save changes"
    end

    def add_contact
      click_link "Add a point of contact"
      fill_in "names[]", with: "Moncef Belyamani-Belyamani"
      fill_in "titles[]", with: "Director of Development and Operations"
      fill_in "contact_emails[]", with: "moncefbelyamani@samaritanhousesanmateo.org"
      fill_in "contact_phones[]", with: "703-555-1212"
      fill_in "contact_faxes[]", with: "703-555-1234"
    end

    def fill_in_contact
      fill_in "names[]", with: "Moncef Belyamani-Belyamani"
      fill_in "titles[]", with: "Director of Development and Operations"
      fill_in "contact_emails[]", with: "moncefbelyamani@samaritanhousesanmateo.org"
      fill_in "contact_phones[]", with: "703-555-1212"
      fill_in "contact_faxes[]", with: "703-555-1234"
    end

    def delete_contact
      click_link "Delete this contact permanently"
      click_button "Save changes"
    end

    def add_fax_number
      click_link "Add a fax number"
      fill_in "fax_number[]", with: "2025551212"
      fill_in "fax_department[]", with: "CalFresh"
      click_button "Save changes"
    end

    def delete_fax
      click_link "Delete this fax number permanently"
      click_button "Save changes"
    end

    def add_url
      click_link "Add a website"
      fill_in "urls[]", with: "http://monfresh.com"
      click_button "Save changes"
    end

    def add_two_urls
      click_link "Add a website"
      fill_in "urls[]", with: "http://ruby.com"
      click_link "Add a website"
      urls = page.all(:xpath, "//input[@type='url' and @name='urls[]']")
      fill_in urls[-1][:id], with: "http://monfresh.com"
      click_button "Save changes"
    end

    def add_email
      click_link "Add a general email"
      fill_in "emails[]", with: "eml@example.org"
      click_button "Save changes"
    end

    def add_two_emails
      click_link "Add a general email"
      fill_in "emails[]", with: "foo@ruby.com"
      click_link "Add a general email"
      emails = page.all(:xpath, "//input[@type='text' and @name='emails[]']")
      fill_in emails[-1][:id], with: "ruby@foo.com"
      click_button "Save changes"
    end

    def delete_all_urls
      find_link("Delete this website permanently", match: :first).click
      find_link("Delete this website permanently", match: :first).click
      click_button "Save changes"
    end

    def delete_all_emails
      find_link("Delete this email permanently", match: :first).click
      find_link("Delete this email permanently", match: :first).click
      click_button "Save changes"
    end

    def add_service_area
      click_link "Add a service area"
      fill_in "service_areas[]", with: "Belmont"
      click_button "Save changes"
    end

    def add_two_service_areas
      click_link "Add a service area"
      fill_in "service_areas[]", with: "Belmont"
      click_link "Add a service area"
      service_areas = page.all(:xpath, "//input[@type='text' and @name='service_areas[]']")
      fill_in service_areas[-1][:id], with: "Atherton"
      click_button "Save changes"
    end

    def delete_all_service_areas
      find_link("Delete this service area permanently", match: :first).click
      find_link("Delete this service area permanently", match: :first).click
      click_button "Save changes"
    end

    def add_two_keywords
      click_link "Add a keyword"
      fill_in "keywords[]", with: "homeless"
      click_link "Add a keyword"
      keywords = page.all(:xpath, "//input[@type='text' and @name='keywords[]']")
      fill_in keywords[-1][:id], with: "CalFresh"
      click_button "Save changes"
    end

    def delete_all_keywords
      find_link("Delete this keyword permanently", match: :first).click
      find_link("Delete this keyword permanently", match: :first).click
      click_button "Save changes"
    end

    def delete_keyword
      find_link("Delete this keyword permanently", match: :first).click
      click_button "Save changes"
    end

    def add_two_admins
      click_link "Add an admin"
      fill_in "admin_emails[]", with: "moncef@foo.com"
      click_link "Add an admin"
      admins = page.all(:xpath, "//input[@type='text' and @name='admin_emails[]']")
      fill_in admins[-1][:id], with: "moncef@otherlocation.com"
      click_button "Save changes"
    end

    def delete_admin
      find_link("Delete this admin permanently", match: :first).click
      click_button "Save changes"
    end

    def delete_all_admins
      find_link("Delete this admin permanently", match: :first).click
      find_link("Delete this admin permanently", match: :first).click
      click_button "Save changes"
    end

    def add_street_address
      click_link "Add a street address"
      fill_in "street", with: "1486 Huntington Avenue, Suite 100"
      fill_in "city", with: "Redwood City"
      fill_in "state", with: "CA"
      fill_in "zip", with: "94080-5932"
      click_button "Save changes"
    end

    def remove_street_address
      click_link "Delete this address permanently"
      click_button "Save changes"
    end

    def remove_mail_address
      click_link "Delete this mailing address permanently"
      click_button "Save changes"
    end

    def add_mail_address
      fill_in "attention", with: "Redwood City Free Medical Clinic"
      fill_in "m_street", with: "1486 Huntington Avenue, Suite 100"
      fill_in "m_city", with: "Redwood City"
      fill_in "m_state", with: "CA"
      fill_in "m_zip", with: "94080-5932"
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
      fill_in "location_name", with: "new samaritan house location"
      fill_in "description", with: "new description"
      fill_in "street", with: "modularity"
      fill_in "city", with: "utopia"
      fill_in "state", with: "XX"
      fill_in "zip", with: "12345"
    end

    def delete_location
      find_link("Permanently delete this location").click
      find_link("I understand the consequences, delete this location").click
    end

    def set_user_as_admin(email, location)
      @admin = create(:admin_user)
      sign_in(@admin.email, @admin.password)
      visit_locations
      click_link location
      click_link "Add an admin"
      fill_in "admin_emails[]", with: email
      click_button "Save changes"
      click_link "Sign out"
    end
  end
end