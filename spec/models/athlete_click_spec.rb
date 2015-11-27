require 'rails_helper'

RSpec.describe AthleteClick, type: :model do
  let(:athlete) { create :athlete }
  it 'updates the athletes counter cache after creation' do
    expect { AthleteClick.create! athlete: athlete }.to change { athlete.clicks_count }.from(0).to(1)
  end
end
