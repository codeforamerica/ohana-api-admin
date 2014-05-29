require "spec_helper"

feature "Delete a location's contacts", :vcr do
  background do
    login_admin
  end

  scenario "when location doesn't have any contacts" do
    visit_location_with_no_phone
    expect(page).to_not have_link "Delete this contact permanently"
  end

  scenario "when location has one contact", :js do
    visit_test_location
    click_link "Delete this contact permanently"
    click_button "Save changes"
    expect(page).
      to have_content "Changes for Admin Test Location successfully saved!"
    expect(page).to_not have_link "Delete this contact permanently"
    add_contact
    click_button "Save changes"
  end
end