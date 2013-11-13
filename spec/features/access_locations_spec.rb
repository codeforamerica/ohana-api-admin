feature "Accessing /locations" do
  # The 'sign_in' method is defined in spec/support/features/session_helpers.rb
  scenario "when signed in as valid regular user" do
    valid_user = FactoryGirl.create(:user)
    sign_in(valid_user.email, valid_user.password)
    visit("/locations")
    expect(page).to have_content 'Below you should see a list of locations'
    expect(page).to_not have_content 'As an admin'
  end

  scenario "when signed in as an admin" do
    valid_user = FactoryGirl.create(:admin_user)
    sign_in(valid_user.email, valid_user.password)
    visit("/locations")
    expect(page).to have_content 'As an admin'
  end

  scenario "when not signed in" do
    visit("/locations")
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end