require "spec_helper"

feature "Update a service's categories", :vcr do
  background do
    login_admin
  end

  scenario "when service doesn't have any categories" do
    visit_location_with_no_phone
    all('input[type=checkbox]').each do |checkbox|
      checkbox.should_not be_checked
    end
  end

  scenario "when adding the 'Disaster Response' category", :js do
    visit_test_location
    find("#category_emergency").should_not be_checked
    # Check Emergency first to reveal the Disaster Response checkbox
    find("#category_emergency").click
    check "category_disaster-response"
    click_button "Save changes"
    visit_test_location
    find("#category_emergency").should be_checked
    find("#category_disaster-response").should be_checked
    reset_categories
    visit_test_location
    find("#category_emergency").should_not be_checked
  end

  scenario "when going to 4th level", :js do
    visit_test_location
    find("#category_health").click
    find("#category_medical-care").click
    find("#category_checkup-test").trigger('click')
    find("#category_vision-tests").click
    click_button "Save changes"
    visit_test_location
    find("#category_vision-tests").should be_checked
    find("#category_checkup-test").should be_checked
    find("#category_medical-care").should be_checked
    find("#category_health").should be_checked
    reset_categories
  end
end
