require 'rails_helper'

describe UsersController do

  describe 'users access' do
    let(:user){ create(:user) }
    let(:second_user){ create(:user) }

    before :each do
      session[:user_id] = user.id
    end

    describe 'GET #edit' do
      it 'user can edit their own info' do
        get :edit, id: user.id
        expect(response).to render_template(:edit)
      end

      it "user cannot edit someone else's info" do
        get :edit, id: second_user.id
        expect(response).to redirect_to root_path
      end

      it 'sets the @user instance variable' do
        get :edit, id: user.id
        expect(assigns(:user)).to match user
      end
    end

    describe 'POST #create' do
      context 'signed-in' do
        it 'redirects to the new user' do
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to user_path(assigns(:user))
        end

        it 'actually creates the user' do
          expect{ post :create, user: attributes_for(:user) }.to change(User, :count).by(1)
        end
      end

      context 'not signed in' do
        it 're-renders the new user form' do
          post :create, user: attributes_for(:user, name: nil)
          expect(response).to render_template :new
        end

        it 'does not create a user' do
          expect{ post :create, user: attributes_for(:user, name: nil) }.to change(User, :count).by(0)
        end
      end
    end

    describe 'DELETE #destroy' do
      before { user }
      it 'user can delete their own account' do
        expect{ delete :destroy, id: user.id }.to change(User, :count).by(-1)
      end

      it "user cannot delete someone else's account" do
        delete :destroy, id: second_user.id
        expect(response).to redirect_to root_path
      end
    end
  end

end
