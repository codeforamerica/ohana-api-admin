require "spec_helper"

feature "Create a new location" do
  background do
    login_user
    visit_locations
    click_link "Add a new location"
  end

  scenario "with all required fields" do
    fill_in "location_name", with: "new location"
    fill_in "description", with: "new description"
    fill_in "short_desc", with: "new short description"
    fill_in "street", with: "modularity"
    fill_in "city", with: "utopia"
    fill_in "state", with: "XX"
    fill_in "zip", with: "12345"
    fill_in "urls[]", with: "http://samaritanhouse.com"
    click_button "Create new location for Samaritan House"
    expect(page).
      to have_content "New location new location successfully created"
  end

  scenario "with empty description" do
    fill_in "location_name", with: "new location"
    fill_in "short_desc", with: "new short description"
    fill_in "street", with: "modularity"
    fill_in "city", with: "utopia"
    fill_in "state", with: "XX"
    fill_in "zip", with: "12345"
    fill_in "urls[]", with: "http://samaritanhouse.com"
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
    fill_in "urls[]", with: "http://samaritanhouse.com"
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
    fill_in "urls[]", with: "http://samaritanhouse.com"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter a short description"
  end

  scenario "with no address" do
    fill_in "location_name", with: "new location"
    fill_in "description", with: "new description"
    fill_in "short_desc", with: "new short description"
    fill_in "urls[]", with: "http://samaritanhouse.com"
    click_button "Create new location for Samaritan House"
    expect(page).to have_content "Please enter at least one type of address"
  end
end