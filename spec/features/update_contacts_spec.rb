require "spec_helper"

feature "Update a location's contacts" do
  background do
    login_admin
  end

  scenario "when location doesn't have any contacts", :vcr do
    visit_location_with_no_phone
    page.should have_no_selector(:xpath, "//input[@type='text' and @name='names[]']")
  end

  scenario "by adding a new contact", { :js => true, :vcr => true } do
    visit_location_with_no_phone
    add_contact
    visit_location_with_no_phone
    find_field('names[]').value.should eq "Moncef"
    find_field('titles[]').value.should eq "Director"
    find_field('contact_emails[]').value.should eq "email@email.org"
    find_field('contact_phones[]').value.should eq "703-555-1212"
    find_field('contact_faxes[]').value.should eq "703-555-1234"
    delete_contact
  end

  scenario "with an empty name", :vcr do
    visit_test_location
    fill_in "names[]", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a contact name"
  end

  scenario "with an empty title", :vcr do
    visit_test_location
    fill_in "titles[]", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a contact title"
  end

  scenario "with an empty email", :vcr do
    visit_test_location
    fill_in "contact_emails[]", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('contact_emails[]').value.should eq ""
  end

  scenario "with an empty phone", :vcr do
    visit_test_location
    fill_in "contact_phones[]", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('contact_phones[]').value.should eq ""
  end

  scenario "with an empty fax", :vcr do
    visit_test_location
    fill_in "contact_faxes[]", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('contact_faxes[]').value.should eq ""
  end

  scenario "with an invalid email", :vcr do
    visit_test_location
    fill_in "contact_emails[]", with: "703"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid email address"
  end

  scenario "with an invalid phone", :vcr do
    visit_test_location
    fill_in "contact_phones[]", with: "703"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US phone number"
  end

  scenario "with an invalid fax", :vcr do
    visit_test_location
    fill_in "contact_faxes[]", with: "202"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US fax number"
  end

end