require "spec_helper"

feature "Update an organization's name", :vcr do
  background do
    login_admin
  end

  scenario "with empty organization name" do
    visit_test_location
    fill_in "org_name", with: ""
    click_button "Save changes"
    expect(page).to have_content "Organization name can't be blank"
  end

  scenario "with valid organization name" do
    visit_test_location
    fill_in "org_name", with: "Health Insurance Counseling and Advocacy Program of San Mateo County (HICAP)"
    click_button "Save changes"
    visit_test_location
    find_field('org_name').value.should eq "Health Insurance Counseling and Advocacy Program of San Mateo County (HICAP)"
    fill_in "org_name", with: "Admin Test Org"
    click_button "Save changes"
  end
end
