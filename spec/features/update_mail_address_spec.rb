require "spec_helper"

feature "Update a location's mailing address" do

  scenario "when location doesn't have a mailing address", :vcr do
    visit_test_location
    find_field('m_street').value.should eq ""
  end

  scenario "by adding a new mailing address", :vcr do
    visit_test_location
    add_mail_address
    visit_test_location
    find_field('m_street').value.should eq "modularity"
    find_field('m_city').value.should eq "utopia"
    find_field('m_state').value.should eq "XX"
    find_field('m_zip').value.should eq "12345"
    remove_mail_address
  end

  scenario "with an empty street", :vcr do
    visit_test_location
    fill_in "m_street", with: ""
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a street"
  end

  scenario "with an empty city", :vcr do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: ""
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a city"
  end

  scenario "with an empty state", :vcr do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: ""
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a state abbreviation"
  end

  scenario "with an empty zip", :vcr do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a ZIP code"
  end

  scenario "with an invalid state", :vcr do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "C"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid state abbreviation"
  end

  scenario "with an invalid zip", :vcr do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "1234"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid ZIP code"
  end
end