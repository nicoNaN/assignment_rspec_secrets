module LoginMacros
  def sign_in(user)
    visit root_path
    click_link 'Login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def bad_sign_in(user)
    click_link 'Login'
    fill_in 'Email', with: user.email + 'bad'
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def sign_out
    visit root_path
    click_link 'Logout'
  end
end
