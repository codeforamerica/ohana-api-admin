require "spec_helper"

feature "Update a service's keywords", :vcr do
  background do
    login_admin
  end

  scenario "when service doesn't have any keywords" do
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='keywords[]']")
  end

  scenario "by adding 2 new keywords", :js do
    visit_location_with_no_phone
    add_two_keywords
    visit_location_with_no_phone
    total_keywords = page.
      all(:xpath, "//input[@type='text' and @name='keywords[]']")
    total_keywords.length.should eq 2
    delete_all_keywords
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='keywords[]']")
  end

  scenario "with empty keyword", :js do
    visit_test_location
    click_link "Add a keyword"
    page.should have_selector(
      :xpath, "//input[@type='text' and @name='keywords[]']")
    click_button "Save changes"
    visit_test_location
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='keywords[]']")
  end

  scenario "with 2 keywords but one is empty", :js do
    visit_test_location
    click_link "Add a keyword"
    fill_in "keywords[]", with: "Food Pantry"
    click_link "Add a keyword"
    click_button "Save changes"
    visit_test_location
    total_keywords = page.
      all(:xpath, "//input[@type='text' and @name='keywords[]']")
    total_keywords.length.should eq 1
    delete_keyword
  end

  scenario "with valid keyword", :js do
    visit_test_location
    click_link "Add a keyword"
    fill_in "keywords[]", with: "Food Pantry"
    click_button "Save changes"
    visit_test_location
    find_field('keywords[]').value.should eq "Food Pantry"
    delete_keyword
  end
end
