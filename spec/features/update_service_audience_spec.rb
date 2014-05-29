require "spec_helper"

feature "Update a service's audience", :vcr do
  background do
    login_admin
  end

  scenario "with full then empty audience" do
    visit_test_location
    fill_in "audience", with: "This is an audience"
    click_button "Save changes"
    visit_test_location
    find_field('audience').value.should eq "This is an audience"
    fill_in "audience", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('audience').value.should eq ""
  end
end
