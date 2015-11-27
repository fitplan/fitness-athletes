require 'rails_helper'

RSpec.describe Athlete::Text, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:description) }
  end
end
