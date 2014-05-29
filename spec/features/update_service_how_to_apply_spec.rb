require "spec_helper"

feature "Update a service's how to apply", :vcr do
  background do
    login_admin
  end

  scenario "with full then empty how to apply" do
    visit_test_location
    fill_in "how_to_apply", with: "This is a how to apply"
    click_button "Save changes"
    visit_test_location
    find_field('how_to_apply').value.should eq "This is a how to apply"
    fill_in "how_to_apply", with: ""
    click_button "Save changes"
    visit_test_location
    find_field('how_to_apply').value.should eq ""
  end
end
