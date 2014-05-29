require "spec_helper"

feature "Accessing /locations", :vcr do
  # The 'sign_in' method is defined in spec/support/features/session_helpers.rb
  scenario "when signed in as valid regular user" do
    valid_user = create(:user)
    login_user(valid_user)
    visit("/locations")
    expect(page).to have_content 'Below you should see a list of locations'
    expect(page).to_not have_content 'As an admin'
    only_admin_locations = all('a').select { |a| a.text.include?("Corps") }
    expect(only_admin_locations).to be_empty
  end

  scenario "when signed in as an admin" do
    valid_user = create(:admin_user)
    login_user(valid_user)
    visit("/locations")
    expect(page).to have_content 'As an admin'
    only_admin_locations = all('a').select { |a| a.text.include?("Corps") }
    expect(only_admin_locations).to_not be_empty
  end

  scenario "when not signed in" do
    visit("/locations")
    expect(page).
      to have_content 'You need to sign in or sign up before continuing.'
  end

  context "when signed in as location admin", :js do
    it "should display the add new location button" do
      new_admin = create(:second_user)
      set_user_as_admin(new_admin.email, "San Mateo Free Medical Clinic")
      login_user(new_admin)
      visit("/san-mateo-free-medical-clinic")
      visit("/locations")
      expect(page).to have_link "Add a new location"
      visit("/san-mateo-free-medical-clinic")
      delete_admin
    end
  end
end