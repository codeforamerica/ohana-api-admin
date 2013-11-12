require "spec_helper"

feature "Update a location's email" do
  background do
    login_admin
  end

  scenario "with empty email", :vcr do
    visit_test_location
    fill_in "emails[]", with: ""
    click_button "Save changes"
    expect(page).to_not have_content "Please enter a valid email address"
  end

  scenario "with valid email", :vcr do
    visit_test_location
    fill_in "emails[]", with: "eml@example.org"
    click_button "Save changes"
    visit_test_location
    find_field('emails[]').value.should eq "eml@example.org"
  end

  scenario "with an invalid email", :vcr do
    visit_test_location
    fill_in "emails[]", with: "example.org"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid email address"
  end
end