require "spec_helper"

feature "Update a location's mailing address", :vcr do
  background do
    login_admin
  end

  scenario "by adding a new mailing address", :js do
    visit_test_location
    click_link "Add a mailing address"
    add_mail_address
    click_button "Save changes"
    visit_test_location
    find_field('attention').value.should eq "Redwood City Free Medical Clinic"
    find_field('m_street').value.should eq "1486 Huntington Avenue, Suite 100"
    find_field('m_city').value.should eq "Redwood City"
    find_field('m_state').value.should eq "CA"
    find_field('m_zip').value.should eq "94080-5932"
    remove_mail_address
    visit_test_location
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='m_street']")
  end

  scenario "with an empty street", :js do
    visit_test_location
    click_link "Add a mailing address"
    fill_in "m_street", with: ""
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a street"
  end

  scenario "with an empty city", :js do
    visit_test_location
    click_link "Add a mailing address"
    fill_in "m_street", with: "123"
    fill_in "m_city", with: ""
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a city"
  end

  scenario "with an empty state", :js do
    visit_test_location
    click_link "Add a mailing address"
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: ""
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a state abbreviation"
  end

  scenario "with an empty zip", :js do
    visit_test_location
    click_link "Add a mailing address"
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: ""
    click_button "Save changes"
    expect(page).to have_content "Please enter a ZIP code"
  end

  scenario "with an invalid state", :js do
    visit_test_location
    click_link "Add a mailing address"
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "C"
    fill_in "m_zip", with: "12345"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid state abbreviation"
  end

  scenario "with an invalid zip", :js do
    visit_test_location
    click_link "Add a mailing address"
    fill_in "m_street", with: "123"
    fill_in "m_city", with: "utopia"
    fill_in "m_state", with: "CA"
    fill_in "m_zip", with: "1234"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid ZIP code"
  end
end
