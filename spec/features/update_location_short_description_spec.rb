require "spec_helper"

feature "Update a location's short description", :vcr do
  background do
    login_admin
  end

  scenario "with valid description" do
    visit_test_location
    fill_in "short_desc", with: "This is a short description"
    click_button "Save changes"
    visit_test_location
    find_field('short_desc').value.should eq "This is a short description"
  end
end
