require "spec_helper"

feature "Update a location's description" do

  scenario "with empty description", :vcr do
    visit_test_location
    fill_in "description", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a description"
  end

  scenario "with valid description", :vcr do
    visit_test_location
    fill_in "description", with: "This is a description"
    click_button "Save changes"
    visit_test_location
    find_field('description').value.should eq "This is a description"
  end
end