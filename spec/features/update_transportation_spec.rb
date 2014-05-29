require "spec_helper"

feature "Update a location's transportation options", :vcr do
  background do
    login_admin
  end

  scenario "with empty transportation options" do
    visit_test_location
    fill_in "transportation", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('transportation').value.should eq ""
  end

  scenario "with non-empty transportation options" do
    visit_test_location
    fill_in "transportation", with: "SAMTRANS stops within 1/2 mile."
    click_button "Save changes"
    visit_test_location
    find_field('transportation').value.should eq "SAMTRANS stops within 1/2 mile."
  end
end
