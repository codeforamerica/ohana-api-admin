require "spec_helper"

feature "Update a service's fees", :vcr do
  background do
    login_admin
  end

  scenario "with full then empty fees" do
    visit_test_location
    fill_in "fees", with: "These are fees"
    click_button "Save changes"
    visit_test_location
    find_field('fees').value.should eq "These are fees"
    fill_in "fees", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('fees').value.should eq ""
  end
end
