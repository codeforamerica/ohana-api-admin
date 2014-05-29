require "spec_helper"

feature "Update a location's languages", :vcr do
  background do
    login_admin
  end

  xscenario "with empty description" do
    visit_test_location
    fill_in "description", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a description"
  end

  xscenario "with valid description" do
    visit_test_location
    fill_in "description", with: "This is a description"
    click_button "Save changes"
    visit_test_location
    find_field('description').value.should eq "This is a description"
  end
end
