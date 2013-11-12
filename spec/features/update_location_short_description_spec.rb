require "spec_helper"

feature "Update a location's short description" do
  background do
    login_admin
  end

  scenario "with empty short description", :vcr do
    visit_test_location
    fill_in "short_desc", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a short description"
  end

  scenario "with valid description", :vcr do
    visit_test_location
    fill_in "short_desc", with: "This is a short description"
    click_button "Save changes"
    visit_test_location
    find_field('short_desc').value.should eq "This is a short description"
  end
end