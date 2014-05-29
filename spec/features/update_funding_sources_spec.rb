require "spec_helper"

feature "Update a service's funding sources", :vcr do
  background do
    login_admin
  end

  xscenario "when service doesn't have any funding sources" do
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='funding_sources[]']")
  end

  xscenario "by adding 2 new funding_sources", :js do
    visit_location_with_no_phone
    add_two_funding_sources
    visit_location_with_no_phone
    delete_two_funding_sources
  end

  xscenario "with empty funding source", :js do
    visit_test_location
    fill_in "funding_sources[]", with: ""
    click_button "Save changes"
    visit_test_location
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='funding_sources[]']")
    add_funding_source
  end

  xscenario "with invalid funding source" do
    visit_test_location
    fill_in "funding_sources[]", with: "Belmont, CA"
    click_button "Save changes"
    expect(page).to have_content "At least one funding source is improperly
      formatted, or is not an accepted city or county name. Please make sure
      all words are capitalized."
  end

  xscenario "with valid funding source" do
    visit_test_location
    fill_in "funding_sources[]", with: "San Mateo County"
    click_button "Save changes"
    visit_test_location
    find_field('funding_sources[]').value.should eq "San Mateo County"
  end
end
