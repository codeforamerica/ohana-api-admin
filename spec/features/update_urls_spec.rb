require "spec_helper"

feature "Update a location's websites" do
  background do
    login_admin
  end

  scenario "when location doesn't have any websites", :vcr do
    visit_location_with_no_phone
    page.should have_no_selector(:xpath, "//input[@type='text' and @name='urls[]']")
  end

  scenario "by adding 2 new websites", { :js => true, :vcr => true } do
    visit_location_with_no_phone
    add_two_urls
    visit_location_with_no_phone
    delete_two_urls
  end

  scenario "with empty website", { :js => true, :vcr => true } do
    visit_test_location
    fill_in "urls[]", with: ""
    click_button "Save changes"
    visit_test_location
    page.should have_no_selector(:xpath, "//input[@type='text' and @name='urls[]']")
    add_url
  end

  scenario "with invalid website", :vcr do
    visit_test_location
    fill_in "urls[]", with: "www.monfresh.com"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid URL"
  end

  scenario "with valid website", :vcr do
    visit_test_location
    fill_in "urls[]", with: "http://codeforamerica.org"
    click_button "Save changes"
    visit_test_location
    find_field('urls[]').value.should eq "http://codeforamerica.org"
  end
end