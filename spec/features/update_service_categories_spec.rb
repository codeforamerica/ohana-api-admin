require "spec_helper"

feature "Update a service's categories" do
  background do
    login_admin
  end

  scenario "when service doesn't have any categories" do
    visit_location_with_no_phone
    all('input[type=checkbox]').each do |checkbox|
      checkbox.should_not be_checked
    end
  end

  scenario "when adding the 'Disaster Response' category", :js => true do
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

  scenario "when going to 4th level", :js => true do
    visit_test_location
    check "category_health"
    check "category_medical-care"
    check "category_checkup-and-test"
    check "category_vision-tests"
    click_button "Save changes"
    visit_test_location
    find("#category_vision-tests").should be_checked
    reset_categories
  end
end