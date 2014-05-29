require "spec_helper"

feature "Update a location's fax numbers", :vcr do
  background do
    login_admin
  end

  scenario "when location doesn't have any fax numbers" do
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='fax_number[]']")
  end

  scenario "by adding a new fax", :js do
    visit_location_with_no_phone
    add_fax_number
    visit_location_with_no_phone
    expect(find_field('fax_number[]').value).to eq "2025551212"
    expect(find_field('fax_department[]').value).to eq "CalFresh"
    delete_fax
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='fax_number[]']")
  end

  scenario "with an invalid fax number" do
    visit_test_location
    fill_in "fax_number[]", with: "703"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid US fax number"
  end

  scenario "with a valid fax number" do
    visit_test_location
    fill_in "fax_number[]", with: "7035551212"
    click_button "Save changes"
    visit_test_location
    find_field('fax_number[]').value.should eq "7035551212"
  end

  scenario "with an empty number" do
    visit_test_location
    fill_in "fax_number[]", with: ""
    click_button "Save changes"
    expect(page).to have_content "Number can't be blank for Fax"
  end

  scenario "with 2 faxes but one is empty", :js do
    visit_test_location # it already has one
    click_link "Add a fax number"
    click_button "Save changes"
    visit_test_location
    total_faxes = page.
      all(:xpath, "//input[@type='text' and @name='fax_number[]']")
    total_faxes.length.should eq 1
  end

  scenario "with 2 faxes but second one is invalid", :js do
    visit_test_location # it already has one
    click_link "Add a fax number"
    total_fax_departments = page.
      all(:xpath, "//input[@type='text' and @name='fax_department[]']")
    fill_in total_fax_departments[-1][:id], with: "Test"
    click_button "Save changes"
    expect(page).to have_content "Number can't be blank for Fax"
  end
end
