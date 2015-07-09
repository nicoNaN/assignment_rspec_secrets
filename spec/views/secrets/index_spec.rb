require 'rails_helper'

describe 'secrets/index.html.erb' do
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
    it 'can see the authors of secrets' do
      render
      expect(rendered).to match('TestUser')
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
    it 'can see the authors of secrets' do
      render
      expect(rendered).to match('hidden')
    end
  end

end
