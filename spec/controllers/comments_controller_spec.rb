require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe '#index' do
    context 'with an invalid athlete' do
      it 'renders a 404 if unable to load the athlete' do
        get :index, athlete_id: 'this-does-not-exist'
        expect(response.status).to eq(404)
      end
    end
    context 'with a valid athlete' do
      let(:athlete) { create :athlete }
      before(:each) {
        rand(100).times { create :comment, commentable: athlete }
        get :index, athlete_id: athlete.slug
      }
      it 'loads the athlete object associated with the id' do
        expect(assigns :athlete).to eq(athlete)
      end
      it 'loads a list of comments for the athlete' do
        expect(assigns :comments).to eq(athlete.comment_threads)
      end
    end
  end
  describe '#create' do
    context 'when logged in' do
      before(:each) { sign_in create(:user) }
      it 'creates a new comment object' do
        expect {
          post :create, comment: FactoryGirl.attributes_for(:comment), athlete_id: create(:athlete).id
        }.to change(Comment,:count).by(1)
      end
    end
    context 'when logged out' do
      it 'prevents the user from commenting' do
        post :create, comment: FactoryGirl.attributes_for(:comment), athlete_id: create(:athlete).id
        expect(response.status).to eq(302)
        expect(response).to redirect_to root_url
      end
    end
  end
end
