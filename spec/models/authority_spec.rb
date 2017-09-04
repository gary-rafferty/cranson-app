require 'rails_helper'

RSpec.describe Authority, type: :model do
  describe 'validations' do
    let(:authority) { build(:authority) }

    describe 'name must be present' do
      it "invalid if name is missing" do
        authority.name = nil
        expect(authority).to_not be_valid
      end
    end
  end
end
