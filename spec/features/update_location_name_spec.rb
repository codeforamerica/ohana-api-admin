require "spec_helper"

feature "Update a location's name", :vcr do
  background do
    login_admin
  end

  scenario "with empty location name" do
    visit_test_location
    fill_in "location_name", with: ""
    click_button "Save changes"
    expect(page).to have_content "Location name can't be blank"
  end

  scenario "with valid location name" do
    visit_test_location
    fill_in "location_name",
      with: "South San Francisco., Juvenile Sexual Responsibility Program"
    click_button "Save changes"
    visit_test_location
    find_field('location_name').
      value.should eq "South San Francisco., Juvenile Sexual Responsibility Program"
    fill_in "location_name", with: "Admin Test Location"
    click_button "Save changes"
  end
end
