include Warden::Test::Helpers
Warden.test_mode!

module Features
  module AdminHelper
    def login_admin
      user = FactoryGirl.create(:admin_user)
      login_as(user, :scope => :user)
    end
  end
end