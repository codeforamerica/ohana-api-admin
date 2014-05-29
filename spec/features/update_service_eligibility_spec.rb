require "spec_helper"

feature "Update a service's eligibility", :vcr do
  background do
    login_admin
  end

  scenario "with full then empty eligibility" do
    visit_test_location
    fill_in "eligibility", with: "This is an eligibility"
    click_button "Save changes"
    visit_test_location
    find_field('eligibility').value.should eq "This is an eligibility"
    fill_in "eligibility", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('eligibility').value.should eq ""
  end
end
