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
    find("#category_101").should_not be_checked
    # Check Emergency first to reveal the Disaster Response checkbox
    find("#category_101").click
    check "category_101-01"
    click_button "Save changes"
    visit_test_location
    find("#category_101").should be_checked
    find("#category_101-01").should be_checked
    reset_categories
    visit_test_location
    find("#category_101").should_not be_checked
  end

  scenario "when going to 4th level", :js do
    visit_test_location
    find("#category_106").click
    find("#category_106-06").click
    find("#category_106-06-04").trigger('click')
    find("#category_106-06-04-06").click
    click_button "Save changes"
    visit_test_location
    find("#category_106-06-04-06").should be_checked
    find("#category_106-06-04").should be_checked
    find("#category_106-06").should be_checked
    find("#category_106").should be_checked
    reset_categories
  end
end
