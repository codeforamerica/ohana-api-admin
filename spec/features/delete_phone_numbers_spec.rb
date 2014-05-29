require "spec_helper"

feature "Delete a location's phone numbers", :vcr do
  background do
    login_admin
  end

  scenario "when location doesn't have any phone numbers" do
    visit_location_with_no_phone
    expect(page).to_not have_link "Delete this number permanently"
  end

  scenario "when location has one number", :js do
    visit_test_location
    click_link "Delete this number permanently"
    click_button "Save changes"
    expect(page).
      to have_content "Changes for Admin Test Location successfully saved!"
    expect(page).to_not have_link "Delete this number permanently"
    add_phone_number
    click_button "Save changes"
  end
end