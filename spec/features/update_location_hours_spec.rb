require "spec_helper"

feature "Update a location's hours", :vcr do
  background do
    login_admin
  end

  scenario "with empty hours" do
    visit_test_location
    fill_in "text_hours", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('text_hours').value.should eq ""
  end

  scenario "with valid hours" do
    visit_test_location
    fill_in "text_hours", with: "Monday-Friday 10am-5pm"
    click_button "Save changes"
    visit_test_location
    find_field('text_hours').value.should eq "Monday-Friday 10am-5pm"
  end
end
