require "spec_helper"

feature "Update a location's mailing address" do
  background do
    login_admin
  end

  scenario "when location doesn't have a mailing address" do
    visit_test_location
    find_field('m_street').value.should eq ""
  end

  scenario "by adding a new mailing address" do
    visit_test_location
    add_mail_address
    visit_test_location
    find_field('m_street').value.should eq "modularity"
    find_field('m_city').value.should eq "utopia"
    find_field('m_state').value.should eq "XX"
    find_field('m_zip').value.should eq "12345"
    remove_mail_address
    visit_test_location
    find_field('m_street').value.should eq ""
  end

  scenario "with an empty street" do
    visit_test_location
    fill_in "m_street", with: ""
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a street"
  end

  scenario "with an empty city" do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: ""
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a city"
  end

  scenario "with an empty state" do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: ""
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a state abbreviation"
  end

  scenario "with an empty zip" do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a ZIP code"
  end

  scenario "with an invalid state" do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "C"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid state abbreviation"
  end

  scenario "with an invalid zip" do
    visit_test_location
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "1234"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid ZIP code"
  end
end