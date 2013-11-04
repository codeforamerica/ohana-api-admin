require "spec_helper"

feature "Update a location's phone numbers" do

  scenario "when location doesn't have any phone numbers", :vcr do
    visit_location_with_no_phone
    page.should have_no_selector(:xpath, "//input[@type='text' and @name='number[]']")
  end

  scenario "by adding a new number", { :js => true, :vcr => true } do
    visit_location_with_no_phone
    add_phone_number
    visit_location_with_no_phone
    find_field('number[]').value.should eq "7035551212"
    find_field('vanity_number[]').value.should eq "703555-ABCD"
    find_field('extension[]').value.should eq "x1223"
    find_field('department[]').value.should eq "CalFresh"
    delete_phone_number
  end

  scenario "with an invalid phone number", :vcr do
    visit_test_location
    fill_in "number[]", with: "703"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US phone number"
  end

  scenario "with a valid phone number", :vcr do
    visit_test_location
    fill_in "number[]", with: "7035551212"
    click_button "Save changes"
    visit_test_location
    find_field('number[]').value.should eq "7035551212"
  end
end