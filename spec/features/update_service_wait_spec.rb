require "spec_helper"

feature "Update a service's wait time", :vcr do
  background do
    login_admin
  end

  scenario "with full then empty wait" do
    visit_test_location
    fill_in "wait", with: "This is a wait"
    click_button "Save changes"
    visit_test_location
    find_field('wait').value.should eq "This is a wait"
    fill_in "wait", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('wait').value.should eq ""
  end
end
