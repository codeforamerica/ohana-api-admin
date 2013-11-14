require "spec_helper"

feature "Create a new location" do
  background do
    login_user
  end

  scenario "with all required fields", :vcr do
    visit_locations
    click_link "Add a new location"
    fill_in "location_name", with: "new location"
    fill_in "description", with: "new description"
    fill_in "short_desc", with: "new short description"
    fill_in "street", with: "modularity"
    fill_in "city", with: "utopia"
    fill_in "state", with: "XX"
    fill_in "zip", with: "12345"
    fill_in "urls[]", with: "http://samaritanhouse.com"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "New location new location successfully created"
  end

  xscenario "with valid description", :vcr do
    visit_test_location
    fill_in "description", with: "This is a description"
    click_button "Save changes"
    visit_test_location
    find_field('description').value.should eq "This is a description"
  end
end