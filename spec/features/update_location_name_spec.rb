require "spec_helper"

feature "Update a location's name" do

  scenario "with empty location name", :vcr do
    visit_test_location
    fill_in "location_name", with: ""
    click_button "Save changes"
    expect(page).to have_content "Location name can't be blank"
  end

  scenario "with valid location name", :vcr do
    visit_test_location
    fill_in "location_name", with: "Admin Test Location"
    click_button "Save changes"
    visit_test_location
    find_field('location_name').value.should eq "Admin Test Location"
  end
end