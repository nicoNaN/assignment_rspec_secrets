require 'rails_helper'

describe SecretsController do

  describe 'secrets access' do
    let(:user){ create(:user) }
    let(:secret){ create(:secret) }
    let(:second_secret){ create(:secret) }

    before :each do
      session[:user_id] = user.id
    end

    describe 'GET #show' do
      it 'gets the secret associated with user id param and sets it to @secret' do
        get :show, id: secret.id
        expect(assigns(:secret)).to match secret
      end
    end

    describe 'GET #edit' do
      it 'user can edit their own secret' do
        get :edit, { id: secret.id }, { user_id: secret.author.id }
        expect(response).to render_template(:edit)
      end

      it "user cannot edit someone else's secret" do
        expect{ get :edit,
              { id: second_secret.id },
              { user_id: secret.author.id } }.to raise_error(/Couldn't find Secret/)
      end

      it 'sets the @secret instance variable' do
        get :edit, { id: secret.id }, { user_id: secret.author.id }
        expect(assigns(:secret)).to match secret
      end
    end

    describe 'POST #create' do
      context 'signed-in' do
        it 'can create a new secret' do
          post :create, secret: attributes_for(:secret)
          expect(assigns(:secret)).to be_persisted
        end
      end

      context 'not signed in' do
        it 'cannot create a new secret' do
          session[:user_id] = nil
          post :create, secret: attributes_for(:secret)
          expect(assigns(:secret)).to eq(nil) # maybe not a good solution
        end
      end
    end

    describe 'DELETE #destroy' do
      before { secret }
      it 'user can delete their own secret' do
        expect{ delete :destroy, { id: secret.id }, { user_id: secret.author.id } }.to change(Secret, :count).by(-1)
      end

      it "user cannot delete someone else's secret" do
        expect{ delete :destroy, { id: second_secret.id }, { user_id: secret.author.id } }.to raise_error(/Couldn't find Secret/)
      end
    end

  end

end
