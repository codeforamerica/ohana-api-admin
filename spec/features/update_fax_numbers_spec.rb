require "spec_helper"

feature "Update a location's fax numbers" do
  background do
    login_admin
  end

  scenario "when location doesn't have any fax numbers", :vcr do
    visit_location_with_no_phone
    page.should have_no_selector(:xpath, "//input[@type='text' and @name='fax_number[]']")
  end

  scenario "by adding a new number", { :js => true, :vcr => true } do
    visit_location_with_no_phone
    click_link "Add a new fax number"
    fill_in "fax_number[]", with: "703"
    fill_in "fax_department[]", with: "CalFresh"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US fax number"
  end

  scenario "with an invalid fax number", :vcr do
    visit_test_location
    fill_in "fax_number[]", with: "703"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US fax number"
  end

  scenario "with a valid fax number", :vcr do
    visit_test_location
    fill_in "fax_number[]", with: "7035551212"
    click_button "Save changes"
    visit_test_location
    find_field('fax_number[]').value.should eq "7035551212"
  end
end