require "spec_helper"

feature "Update a location's email", :vcr do
  background do
    login_admin
  end

  scenario "with empty email", :js do
    visit_test_location
    fill_in "emails[]", with: ""
    click_button "Save changes"
    visit_test_location
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='emails[]']")
    add_email
  end

  scenario "with valid email" do
    visit_test_location
    fill_in "emails[]", with: "moncefbelyamani@samaritanhousesanmateo.org"
    click_button "Save changes"
    visit_test_location
    find_field('emails[]').value.should eq "moncefbelyamani@samaritanhousesanmateo.org"
  end

  scenario "with an invalid email" do
    visit_test_location
    fill_in "emails[]", with: "example.org"
    click_button "Save changes"
    expect(page).to have_content "Please enter a valid email address"
  end

  scenario "by adding 2 new emails", :js do
    visit_location_with_no_phone
    add_two_emails
    visit_location_with_no_phone
    emails = page.all(:xpath, "//input[@type='text' and @name='emails[]']")
    email_id = emails[-1][:id]
    find_field(email_id).value.should eq "ruby@foo.com"
    delete_all_emails
    visit_location_with_no_phone
    page.should have_no_selector(
      :xpath, "//input[@type='text' and @name='emails[]']")
  end

  scenario "with 2 emails but one is empty", :js do
    visit_test_location # it already has one
    click_link "Add a general email"
    click_button "Save changes"
    visit_test_location
    total_emails = page.
      all(:xpath, "//input[@type='text' and @name='emails[]']")
    total_emails.length.should eq 1
  end
end
