module SecretsMacros

  def create_secret
    click_link 'All Secrets'
    click_link 'New Secret'

    fill_in 'Title', with: 'TestSecret'
    fill_in 'Body', with: 'TestSecret body!'
  end

  def create_bad_secret
    click_link 'All Secrets'
    click_link 'New Secret'

    fill_in 'Title', with: 'TestSecret'
    fill_in 'Body', with: ''
  end


end
