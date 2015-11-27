require 'rails_helper'

RSpec.describe Athlete::Base, type: :model do
  let(:athlete) { create :athlete }

  it 'can be tagged' do
    expect do
      athlete.tag_list << 'awesome'
      athlete.save
    end.to change { athlete.tag_list }.from([]).to(['awesome'])
  end

end
