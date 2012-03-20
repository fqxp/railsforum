module ControllerMacros
  def no_logged_in_user
    before (:each) do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end
  end

  def login_user(*fields)
    before (:each) do
      request.env['devise.mapping'] = Devise.mappings[:user]
      user = Factory.create(:user, *fields)
      #user.confirm!
      sign_in user
    end
  end
end
