require 'rails_helper'

describe 'shared/_navigation.html.erb' do
  before do
    secrets = [create(:secret)] * 5
    assign(:secrets, secrets)
  end

  context 'signed-in' do
    before do
      def view.signed_in_user?
        true
      end
      def view.current_user
        FactoryGirl.create(:user)
      end
    end

    it 'can see a logout link' do
      render
      expect(rendered).to match ('Logout')
    end
  end

  context 'not signed in' do
    before do
      def view.signed_in_user?
        false
      end
      def view.current_user
        nil
      end
    end
    it 'can see a login link' do
      render
      expect(rendered).to match ('Login')
    end
  end

end
