require "spec_helper"

feature "Update a location's kind" do
  background do
    login_admin
  end

  scenario "with empty kind" do
    visit_test_location
    select("--CHOOSE--", :from => "kind")
    click_button "Save changes"
    expect(page).to_not have_content "Please enter a kind"
  end

  scenario "with valid kind" do
    visit_test_location
    select("Test", :from => "kind")
    click_button "Save changes"
    visit_test_location
    find_field('kind').value.should eq "test"
  end
end