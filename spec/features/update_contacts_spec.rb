require "spec_helper"

feature "Update a location's contacts", :vcr do
  background do
    login_admin
  end

  scenario "when location doesn't have any contacts"  do
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='names[]']")
  end

  scenario "by adding a new contact", :js do
    visit_location_with_no_phone
    add_contact
    click_button "Save changes"
    visit_location_with_no_phone
    find_field('names[]').value.should eq "Moncef Belyamani-Belyamani"
    find_field('titles[]').
      value.should eq "Director of Development and Operations"
    find_field('contact_emails[]').
      value.should eq "moncefbelyamani@samaritanhousesanmateo.org"
    find_field('contact_phones[]').value.should eq "703-555-1212"
    find_field('contact_faxes[]').value.should eq "703-555-1234"
    delete_contact
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='names[]']")
  end

  scenario "with an empty name" do
    visit_test_location
    fill_in "names[]", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a contact name"
  end

  scenario "with an empty title" do
    visit_test_location
    fill_in "titles[]", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a contact title"
  end

  scenario "with an empty email" do
    visit_test_location
    fill_in "contact_emails[]", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('contact_emails[]').value.should eq ""
  end

  scenario "with an empty phone" do
    visit_test_location
    fill_in "contact_phones[]", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('contact_phones[]').value.should eq ""
  end

  scenario "with an empty fax" do
    visit_test_location
    fill_in "contact_faxes[]", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('contact_faxes[]').value.should eq ""
  end

  scenario "with an invalid email" do
    visit_test_location
    fill_in "contact_emails[]", with: "703"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid email address"
  end

  scenario "with an invalid phone" do
    visit_test_location
    fill_in "contact_phones[]", with: "703"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US phone number"
  end

  scenario "with an invalid fax" do
    visit_test_location
    fill_in "contact_faxes[]", with: "202"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US fax number"
  end

  scenario "with 2 contacts but one is empty", :js do
    visit_test_location # it already has one
    click_link "Add a point of contact"
    click_button "Save changes"
    visit_test_location
    total_contacts = page.
      all(:xpath, "//input[@type='text' and @name='contact_phones[]']")
    total_contacts.length.should eq 1
  end

  scenario "with 2 contacts but second one is invalid", :js do
    visit_test_location # it already has one
    click_link "Add a point of contact"
    total_contact_phones = page.
      all(:xpath, "//input[@type='text' and @name='contact_phones[]']")
    fill_in total_contact_phones[-1][:id], with: "202-555-1212"
    click_button "Save changes"
    expect(page).to have_content "Please enter a contact name"
  end
end
