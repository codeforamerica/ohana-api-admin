require "spec_helper"

feature "Create a new location", :vcr do
  background do
    user = create(:user)
    login_user(user)
    visit("/locations/new")
  end

  describe "when adding a new location" do
    it "should prepopulate the website" do
      find_field('urls[]').value.should eq "http://www.samaritanhouse.com"
    end
  end

  scenario "with all required fields", :js do
    fill_in "location_name", with: "new samaritan house location"
    fill_in "description", with: "new description"
    fill_in "street", with: "1486 Huntington Avenue, Suite 100"
    fill_in "city", with: "Redwood City"
    fill_in "state", with: "XX"
    fill_in "zip", with: "94080-5932"
    click_button "Create new location for Samaritan House"
    find_field('location_name').value.should eq "new samaritan house location"
    find_field('description').value.should eq "new description"
    find_field('street').value.should eq "1486 Huntington Avenue, Suite 100"
    find_field('city').value.should eq "Redwood City"
    find_field('state').value.should eq "XX"
    find_field('zip').value.should eq "94080-5932"
    delete_location
  end

  scenario "with empty description" do
    fill_in "location_name", with: "new samaritan house location"
    fill_in "street", with: "1486 Huntington Avenue, Suite 100"
    fill_in "city", with: "Redwood City"
    fill_in "state", with: "XX"
    fill_in "zip", with: "94080-5932"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a description"
  end

  scenario "with empty name" do
    fill_in "description", with: "new description"
    fill_in "street", with: "modularity"
    fill_in "city", with: "utopia"
    fill_in "state", with: "XX"
    fill_in "zip", with: "12345"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Location name can't be blank!"
  end

  scenario "with no address" do
    fill_in "location_name", with: "new samaritan house location"
    fill_in "description", with: "new description"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter at least one type of address"
  end

  scenario "with valid mailing address", :js do
    fill_in_all_required_fields
    add_mail_address
    click_button "Create new location for Samaritan House"
    find_field('attention').value.should eq "Redwood City Free Medical Clinic"
    find_field('m_street').value.should eq "1486 Huntington Avenue, Suite 100"
    find_field('m_city').value.should eq "Redwood City"
    find_field('m_state').value.should eq "CA"
    find_field('m_zip').value.should eq "94080-5932"
    delete_location
  end

  scenario "with valid phone number", :js do
    fill_in_all_required_fields
    add_phone_number
    click_button "Create new location for Samaritan House"
    find_field('number[]').value.should eq "7035551212"
    find_field('vanity_number[]').value.should eq "703555-ABCD"
    find_field('extension[]').value.should eq "x1223"
    find_field('department[]').value.should eq "CalFresh"
    delete_location
  end

  scenario "with an invalid phone number", :js do
    fill_in_all_required_fields
    click_link "Add a phone number"
    fill_in "number[]", with: "703"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a valid US phone number"
  end

  scenario "with valid fax number", :js do
    fill_in_all_required_fields
    click_link "Add a fax number"
    fill_in "fax_number[]", with: "7035551212"
    fill_in "fax_department[]", with: "CalFresh"
    click_button "Create new location for Samaritan House"
    find_field('fax_number[]').value.should eq "7035551212"
    find_field('fax_department[]').value.should eq "CalFresh"
    delete_location
  end

  scenario "with an invalid fax number", :js do
    fill_in_all_required_fields
    click_link "Add a fax number"
    fill_in "fax_number[]", with: "703"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a valid US fax number"
  end

  scenario "with a valid contact", :js do
    fill_in_all_required_fields
    fill_in_contact
    click_button "Create new location for Samaritan House"
    find_field('names[]').value.should eq "Moncef Belyamani-Belyamani"
    find_field('titles[]').
      value.should eq "Director of Development and Operations"
    find_field('contact_emails[]').
      value.should eq "moncefbelyamani@samaritanhousesanmateo.org"
    find_field('contact_phones[]').value.should eq "703-555-1212"
    find_field('contact_faxes[]').value.should eq "703-555-1234"
    delete_location
  end

  scenario "with an empty contact name" do
    fill_in_all_required_fields
    fill_in "names[]", with: ""
    fill_in "titles[]", with: "Director"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a contact name"
  end

  scenario "with an empty contact title" do
    fill_in_all_required_fields
    fill_in "names[]", with: "Contact Name"
    fill_in "titles[]", with: ""
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a contact title"
  end

  scenario "with an invalid contact phone" do
    fill_in_all_required_fields
    fill_in "names[]", with: "Contact Name"
    fill_in "titles[]", with: "Contact Title"
    fill_in "contact_phones[]", with: "703"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a valid US phone number"
  end

  scenario "with an invalid contact fax" do
    fill_in_all_required_fields
    fill_in "names[]", with: "Contact Name"
    fill_in "titles[]", with: "Contact Title"
    fill_in "contact_faxes[]", with: "202"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a valid US fax number"
  end

  scenario "with valid location email", :js do
    fill_in_all_required_fields
    fill_in "emails[]", with: "moncefbelyamani@samaritanhousesanmateo.org"
    click_button "Create new location for Samaritan House"
    find_field('emails[]').value.should eq "moncefbelyamani@samaritanhousesanmateo.org"
    delete_location
  end

  scenario "with valid location hours", :js do
    fill_in_all_required_fields
    fill_in "text_hours", with: "Monday-Friday 10am-5pm"
    click_button "Create new location for Samaritan House"
    find_field('text_hours').value.should eq "Monday-Friday 10am-5pm"
    delete_location
  end

  scenario "when adding an accessibility option", :js do
    fill_in_all_required_fields
    check "accessibility_elevator"
    click_button "Create new location for Samaritan House"
    find("#accessibility_elevator").should be_checked
    delete_location
  end

  scenario "when adding transportation option", :js do
    fill_in_all_required_fields
    fill_in "transportation", with: "SAMTRANS stops within 1/2 mile."
    click_button "Create new location for Samaritan House"
    find_field('transportation').value.should eq "SAMTRANS stops within 1/2 mile."
    delete_location
  end

  scenario "when adding a website", :js do
    fill_in_all_required_fields
    click_link "Add a website"
    urls = page.all(:xpath, "//input[@type='url' and @name='urls[]']")
    fill_in urls[-1][:id], with: "http://monfresh.com"
    click_button "Create new location for Samaritan House"
    urls = page.all(:xpath, "//input[@type='url' and @name='urls[]']")
    url_id = urls[-1][:id]
    find_field(url_id).value.should eq "http://monfresh.com"
    delete_location
  end

  scenario "when adding an audience", :js do
    fill_in_all_required_fields
    fill_in "audience", with: "This is an audience"
    click_button "Create new location for Samaritan House"
    find_field('audience').value.should eq "This is an audience"
    delete_location
  end

  scenario "when adding an eligibility", :js do
    fill_in_all_required_fields
    fill_in "eligibility", with: "This is an eligibility"
    click_button "Create new location for Samaritan House"
    find_field('eligibility').value.should eq "This is an eligibility"
    delete_location
  end

  scenario "when adding fees", :js do
    fill_in_all_required_fields
    fill_in "fees", with: "These are fees"
    click_button "Create new location for Samaritan House"
    find_field('fees').value.should eq "These are fees"
    delete_location
  end

  scenario "when adding how to apply", :js do
    fill_in_all_required_fields
    fill_in "how_to_apply", with: "This is how to apply"
    click_button "Create new location for Samaritan House"
    find_field('how_to_apply').value.should eq "This is how to apply"
    delete_location
  end

  scenario "when adding wait time", :js do
    fill_in_all_required_fields
    fill_in "wait", with: "This is a wait time"
    click_button "Create new location for Samaritan House"
    find_field('wait').value.should eq "This is a wait time"
    delete_location
  end

  xscenario "when adding a valid service area", :js do
    fill_in_all_required_fields
    click_link "Add a service area"
    fill_in "service_areas[]", with: "Belmont"
    click_button "Create new location for Samaritan House"
    find_field('service_areas[]').value.should eq "Belmont"
    delete_location
  end

  xscenario "when adding an invalid service area", :js do
    fill_in_all_required_fields
    click_link "Add a service area"
    fill_in "service_areas[]", with: "Belmont, CA"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "At least one service area is improperly
      formatted, or is not an accepted city or county name. Please make sure
      all words are capitalized."
  end

  scenario "when adding a keyword", :js do
    fill_in_all_required_fields
    click_link "Add a keyword"
    fill_in "keywords[]", with: "Food Pantry"
    click_button "Create new location for Samaritan House"
    find_field('keywords[]').value.should eq "Food Pantry"
    delete_location
  end

  scenario "when adding categories", :js do
    fill_in_all_required_fields
    find("#category_emergency").click
    check "category_disaster-response"
    click_button "Create new location for Samaritan House"
    find("#category_emergency").should be_checked
    find("#category_disaster-response").should be_checked
    delete_location
  end
end

describe "creating a new location as user with generic email", :vcr do
  context "after creating the location", :js do
    it "sets the current user as an admin for the new location" do
      user = create(:second_user)
      set_user_as_admin(user.email, "Little House")
      login_user(user)
      visit("/locations/new")
      fill_in_all_required_fields
      click_button "Create new location for Peninsula Volunteers"
      find_field('admin_emails[]').value.should eq user.email
      delete_location
      visit("/little-house")
      delete_admin
    end
  end
end