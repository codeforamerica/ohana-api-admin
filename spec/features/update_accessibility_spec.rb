require "spec_helper"

feature "Update a location's accessibility options", :vcr do
  background do
    login_admin
  end

  scenario "when location doesn't have any options" do
    visit_location_with_no_phone
    all('input[type=checkbox]').each do |checkbox|
      checkbox.should_not be_checked
    end
  end

  scenario "when adding an option" do
    visit_test_location
    check "accessibility_elevator"
    click_button "Save changes"
    expect(page).
      to have_content "Changes for Admin Test Location successfully saved!"
    find("#accessibility_elevator").should be_checked
  end

  scenario "when removing an option" do
    visit_test_location
    uncheck "accessibility_restroom"
    click_button "Save changes"
    expect(page).
      to have_content "Changes for Admin Test Location successfully saved!"
    find("#accessibility_restroom").should_not be_checked
    reset_accessibility
  end

  scenario "when adding all options" do
    visit_test_location
    set_all_accessibility
    visit_test_location
    within_fieldset("accessibility") do
      all('input[type=checkbox]').each do |checkbox|
        checkbox.should be_checked unless checkbox[:id].match("accessibility").nil?
      end
    end
    reset_accessibility
  end
end