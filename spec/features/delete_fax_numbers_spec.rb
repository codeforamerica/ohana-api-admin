require "spec_helper"

feature "Delete a location's fax numbers" do

  scenario "when location doesn't have any fax numbers", :vcr do
    visit_location_with_no_phone
    expect(page).to_not have_link "Delete this fax number permanently"
  end

  scenario "when location has one fax number", { :js => true, :vcr => true } do
    visit_test_location
    click_link "Delete this fax number permanently"
    click_button "Save changes"
    visit_test_location
    expect(page).to_not have_link "Delete this fax number permanently"
    add_fax_number
  end
end