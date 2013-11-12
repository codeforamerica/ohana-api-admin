require "spec_helper"

feature "Update a location's street address" do
  background do
    login_admin
  end

  scenario "when location doesn't have a street address", :vcr do
    visit_location_with_no_phone
    find_field('street').value.should eq ""
  end

  scenario "by adding a new street address", :vcr do
    visit_location_with_no_phone
    add_street_address
    visit_location_with_no_phone
    find_field('street').value.should eq "modularity"
    find_field('city').value.should eq "utopia"
    find_field('state').value.should eq "XX"
    find_field('zip').value.should eq "12345"
    remove_street_address
  end

    scenario "with an empty street", :vcr do
    visit_test_location
    fill_in "street", with: ""
    fill_in "city", with: "utopia"
    fill_in "state", with: "CA"
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a street"
  end

  scenario "with an empty city", :vcr do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: ""
    fill_in "state", with: "CA"
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a city"
  end

  scenario "with an empty state", :vcr do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: ""
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a state abbreviation"
  end

  scenario "with an empty zip", :vcr do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: "CA"
    fill_in "zip", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a ZIP code"
  end

  scenario "with an invalid state", :vcr do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: "C"
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid state abbreviation"
  end

  scenario "with an invalid zip", :vcr do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: "CA"
    fill_in "zip", with: "1234"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid ZIP code"
  end
end