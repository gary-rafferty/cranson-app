require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'validations' do
    let(:plan) { build(:plan) }

    describe 'presence of required attrs' do
      %w{status description reference location reference registration_date}.each do |attr|
        it "invalid if #{attr} is missing" do
          plan.send("#{attr}=", nil)
          expect(plan).to_not be_valid
        end
      end
    end
  end

  describe 'scopes' do
    describe '#decided' do
      let!(:decided)   { create(:plan) }
      let!(:undecided) { create(:plan, status: 'Undecided') }

      it 'retrieves only plans with decisions' do
        expect(Plan.decided.first).to eq decided
      end
    end
  end
end
