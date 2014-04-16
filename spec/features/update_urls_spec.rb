require "spec_helper"

feature "Update a location's websites" do
  background do
    login_admin
  end

  scenario "when location doesn't have any websites" do
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='urls[]']")
  end

  scenario "by adding 2 new websites", :js => true do
    visit_location_with_no_phone
    add_two_urls
    visit_location_with_no_phone
    expect(page).to have_link "Delete this website permanently"
    delete_all_urls
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='urls[]']")
  end

  scenario "with 2 urls but one is empty", :js => true do
    visit_test_location # it already has one
    click_link "Add a website"
    click_button "Save changes"
    visit_test_location
    total_urls = page.
      all(:xpath, "//input[@type='text' and @name='urls[]']")
    total_urls.length.should eq 1
  end

  scenario "with invalid website" do
    visit_test_location
    fill_in "urls[]", with: "www.monfresh.com"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid URL"
  end

  scenario "with valid website" do
    visit_test_location
    fill_in "urls[]", with: "http://codeforamerica.org"
    click_button "Save changes"
    visit_test_location
    find_field('urls[]').value.should eq "http://codeforamerica.org"
  end
end