require "spec_helper"

feature "Accessing a specific location", :vcr do
  scenario "when location doesn't include generic email" do
    user = create(:second_user)
    login_user(user)
    visit("/redwood-city-free-medical-clinic")
    expect(page).to have_content "Sorry, you don't have access to that page"
  end

  scenario "when location doesn't include domain name" do
    user = create(:user)
    login_user(user)
    visit("/main-library")
    expect(page).to have_content "Sorry, you don't have access to that page"
  end

  scenario "when location includes domain name" do
    user = create(:user)
    login_user(user)
    visit("/redwood-city-free-medical-clinic")
    expect(page).to_not have_content "Sorry, you don't have access to that page"
  end

  scenario "when user is location admin", :js do
    new_admin = create(:second_user)
    set_user_as_admin(new_admin.email, "San Mateo Free Medical Clinic")
    login_user(new_admin)
    visit("/san-mateo-free-medical-clinic")
    expect(page).to_not have_content "Sorry, you don't have access to that page"
    delete_admin
  end

  scenario "when user is location admin but has non-generic email", :js do
    new_admin = create(:user)
    set_user_as_admin(new_admin.email, "Little House")
    sign_in(new_admin.email, new_admin.password)
    visit("/little-house")
    expect(page).to have_content "Sorry, you don't have access to that page"
    click_link "Sign out"
    sign_in(@admin.email, @admin.password)
    visit("/little-house")
    delete_admin
    click_link "Sign out"
  end

  scenario "when user is master admin" do
    login_admin
    visit("/little-house")
    expect(page).to_not have_content "Sorry, you don't have access to that page"
  end

  context "when user doesn't belong to any locations" do
    it "denies access to create a new location" do
      user = create(:third_user)
      login_user(user)
      visit("/locations/new")
      expect(page).to have_content "Sorry, you don't have access to that page"
      visit("/locations")
      expect(page).to_not have_link "Add a new location"
    end
  end
end