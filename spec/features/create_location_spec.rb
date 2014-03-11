require "spec_helper"

feature "Create a new location" do
  background do
    login_user
    visit_locations
    click_link "Add a new location"
  end

  scenario "with all required fields", :js => true do
    fill_in "location_name", with: "new location"
    fill_in "description", with: "new description"
    fill_in "short_desc", with: "new short description"
    fill_in "street", with: "1486 Huntington Avenue, Suite 100"
    fill_in "city", with: "Redwood City"
    fill_in "state", with: "XX"
    fill_in "zip", with: "94080-5932"
    click_button "Create new location for Samaritan House"
    expect(page).
      to have_content "New location \"new location\" for Samaritan House successfully created"
  end

  scenario "with empty description" do
    fill_in "location_name", with: "new location"
    fill_in "short_desc", with: "new short description"
    fill_in "street", with: "1486 Huntington Avenue, Suite 100"
    fill_in "city", with: "Redwood City"
    fill_in "state", with: "XX"
    fill_in "zip", with: "94080-5932"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a description"
  end

  scenario "with empty name" do
    fill_in "description", with: "new description"
    fill_in "short_desc", with: "new short description"
    fill_in "street", with: "modularity"
    fill_in "city", with: "utopia"
    fill_in "state", with: "XX"
    fill_in "zip", with: "12345"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Location name can't be blank!"
  end

  scenario "with empty short description" do
    fill_in "location_name", with: "new location"
    fill_in "description", with: "new description"
    fill_in "street", with: "modularity"
    fill_in "city", with: "utopia"
    fill_in "state", with: "XX"
    fill_in "zip", with: "12345"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a short description"
  end

  scenario "with no address" do
    fill_in "location_name", with: "new location"
    fill_in "description", with: "new description"
    fill_in "short_desc", with: "new short description"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter at least one type of address"
  end

  scenario "with service fields filled out", :js => true do
    fill_in_all_required_fields
    fill_in "fees", with: "no fees"
    find("#category_emergency").click
    check "category_disaster-response"
    click_button "Create new location for Samaritan House"
    visit("/locations")
    visit("/locations")
    #click_link "new location with service fields"
    page.all('a')[-2].click
    expect(page).to have_content "no fees"
    find("#category_emergency").should be_checked
    find("#category_disaster-response").should be_checked
  end
end