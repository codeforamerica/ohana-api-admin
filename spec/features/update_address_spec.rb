require "spec_helper"

feature "Update a location's street address", :vcr do
  background do
    login_admin
  end

  scenario "by adding a new street address", :js do
    visit_location_with_no_phone
    add_street_address
    visit_location_with_no_phone
    find_field('street').value.should eq "1486 Huntington Avenue, Suite 100"
    find_field('city').value.should eq "Redwood City"
    find_field('state').value.should eq "CA"
    find_field('zip').value.should eq "94080-5932"
    remove_street_address
    visit_location_with_no_phone
    expect(page).to have_link "Add a street address"
  end

  scenario "when leaving location without address or mail address", :js do
    visit_location_with_no_phone
    remove_mail_address
    expect(page).to have_content "Please enter at least one type of address"
  end

  scenario "with an empty street" do
    visit_test_location
    fill_in "street", with: ""
    fill_in "city", with: "utopia"
    fill_in "state", with: "CA"
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a street"
  end

  scenario "with an empty city" do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: ""
    fill_in "state", with: "CA"
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a city"
  end

  scenario "with an empty state" do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: ""
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a state abbreviation"
  end

  scenario "with an empty zip" do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: "CA"
    fill_in "zip", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a ZIP code"
  end

  scenario "with an invalid state" do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: "C"
    fill_in "zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid state abbreviation"
  end

  scenario "with an invalid zip" do
    visit_test_location
    fill_in "street", with: "123"
    fill_in "city", with: "utopia"
    fill_in "state", with: "CA"
    fill_in "zip", with: "1234"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid ZIP code"
  end
end