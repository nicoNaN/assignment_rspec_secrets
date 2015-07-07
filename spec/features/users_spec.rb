require 'rails_helper'

feature 'User accounts feature testing' do
  before do
    visit root_path
  end

  let(:user){ create(:user) }

  context 'as a visitor' do

    scenario 'sign up for an account' do
      click_link 'All Users'
      click_link 'New User'

      fill_in 'Name', with: 'TestUser'
      fill_in 'Email', with: 'TestUser@foo.bar'
      fill_in 'Password', with: 'testing123'
      fill_in 'Password confirmation', with: 'testing123'

      expect{ click_button 'Create User' }.to change(User, :count).by(1)
      expect(page).to have_content 'User was successfully created.'
    end

    scenario 'sign up for an account with bad info' do
      click_link 'All Users'
      click_link 'New User'

      fill_in 'Name', with: 'TestUser'
      fill_in 'Email', with: 'TestUser@foo.bar'
      fill_in 'Password', with: 't'
      fill_in 'Password confirmation', with: 't'

      click_button 'Create User'
      expect(current_path).to eq(users_path)
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end

    scenario 'log in to my existing account' do
      sign_in(user)

      expect(current_path).to eq(root_path)
      expect(page).to have_content "Welcome, #{user.name}!"
      expect(page).to have_content 'Logout'
    end

    scenario 'attempt to log in to a nonexistent account' do
      bad_sign_in(user)

      expect(current_path).to eq(session_path)
    end
  end

end
