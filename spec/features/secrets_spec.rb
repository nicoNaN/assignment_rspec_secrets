require 'rails_helper'

feature 'Secrets feature testing' do
  before do
    visit root_path
  end

  let(:user){ create(:user) }
  let(:secret){ create(:secret) }

  context 'as a visitor' do
    scenario 'view all secrets' do
      expect(page).to have_content 'Listing secrets'
      expect(page).to have_content 'Title'
      expect(page).to have_content 'Body'
      expect(page).to have_content 'Author'
      expect(page).to have_content 'New Secret'
    end
  end

  context 'as a signed-in user' do
    before do
      sign_in(user)
    end

    scenario 'create a secret' do
      create_secret

      expect{ click_button 'Create Secret' }.to change(Secret, :count).by(1)
      expect(current_path).to eq(secret_path(Secret.last.id))
      expect(page).to have_content 'Secret was successfully created.'
    end

    scenario 'create a secret with bad info' do
      create_bad_secret

      click_button 'Create Secret'
      expect(current_path).to eq(secrets_path)
      expect(page).to have_content 'errors prohibited this secret from being saved:'
    end

    scenario 'edit a secret properly' do
      create_secret
      click_button 'Create Secret'
      click_link 'Edit'

      fill_in 'Title', with: 'Edited secret!'
      click_button 'Update Secret'

      expect(page).to have_content 'Secret was successfully updated.'
    end

    scenario 'edit a secret improperly' do
      create_secret
      click_button 'Create Secret'
      click_link 'Edit'

      fill_in 'Title', with: ''
      click_button 'Update Secret'

      expect(page).to have_content 'errors prohibited this secret from being saved:'
    end
  end
end
