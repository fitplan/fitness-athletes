require 'rails_helper'

RSpec.describe AthletesController, type: :controller do
  let(:user)        { create :user }
  let(:athlete_object) { create :athlete }

  describe '#new' do
    subject { get :new }

    context 'when logged in' do
      before(:each) { sign_in user }
      it 'renders the new athlete form' do
        expect(subject).to render_template('athletes/new')
      end
    end

    context 'when logged out' do
      it 'reponds with a redirect to login' do
        subject
        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#create' do
    subject { post :create, athlete: FactoryGirl.attributes_for(:athlete) }

    context 'when logged in' do
      before(:each) { sign_in user }

      it 'creates a athlete object' do
        expect { subject }.to change { Athlete::Base.count }.by(1)
      end

      context 'with invalid data' do
        subject { post :create, athlete: FactoryGirl.attributes_for(:athlete).except(:title, :url) }

        it 'does not create a athlete object' do
          expect { subject }.to_not change { Athlete::Base.count }
        end
      end

    end

    context 'when logged out' do
      it 'reponds with a redirect to login' do
        subject
        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#index' do
    subject { get :index }

    context 'with a specific tag' do
      let(:tags) { ['cool', 'lame', 'awesome', 'super cool'] }
      let(:tag)  { tags.sample }

      it 'assigns @athletes to only athletes with the specified tag' do
        athlete_object.tag_list << tag
        athlete_object.save!
        get :index, tag: tag
        expect(assigns :athletes).to eq(athlete_object.created_at.to_date => [athlete_object])
      end

    end

    context 'with a specific date' do
      let(:random_date) { (Time.zone.today - rand(5).years - rand(365).days).to_date }
      let(:date_params) { { year: random_date.year, month: random_date.month, day: random_date.day } }

      it 'assigns @athletes to only athletes from that date' do
        num = rand(10) + 3
        athletes = num.times.map { create :athlete, created_at: random_date.to_time }
        get :index, date_params
        expect(assigns :athletes).to eq(random_date => athletes)
      end

    end

    it 'should assign @athletes' do
      subject
      expect(assigns :athletes).not_to be_nil
    end

    it 'should render the index template' do
      expect(subject).to render_template('athletes/index')
    end
  end

  describe '#submitted_by_user' do
    subject { get :submitted_by_user, user_id: athlete_object.user.slug }

    it 'should assign @athletes to all athletes submitted by a user' do
      subject
      expect(assigns :athletes).to eq(athlete_object.user.athletes)
    end
  end

  describe '#liked_by_user' do
    subject { get :liked_by_user, user_id: user.slug }

    it 'assigns @athletes to all athletes upvoted by a user' do
      athletes = 5.times.map { create :athlete }
      athletes.each { |pst| user.up_votes pst }
      subject
      expect(assigns :athletes).to eq(athletes)
    end
  end

  describe '#upvote' do
    subject { post :upvote, id: athlete_object.slug }

    context 'when logged in' do
      before(:each) { sign_in user }

      it 'increments the votes for an object' do
        expect { subject }.to change { athlete_object.get_upvotes.count }.by(1)
      end
    end

    context 'when logged out' do
      it 'responds with a redirect to login' do
        subject
        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#outbound' do
    subject { get :outbound, id: athlete_object.id }

    it 'creates a AthleteClick object' do
      expect { subject }.to change { athlete_object.clicks.count }.by(1)
    end

    context 'when logged in' do
      before(:each) { sign_in user }
      it 'creates a AthleteClick object with associated to the current user' do
        subject
        expect(athlete_object.clicks.last.user).not_to be_nil
        expect(athlete_object.clicks.last.user).to eq(user)
      end
    end
  end

end
