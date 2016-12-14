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
    let!(:decided) { create(:plan) }

    describe '#decided' do
      it 'retrieves only plans with decisions' do
        expect(Plan.decided.first).to eq decided
      end
    end

    describe '#invalid_or_withdrawn' do
      let!(:invalid) { create(:plan, status: 'Invalid or Withdrawn') }

      it 'retrieves only invalid or withdrawn plans' do
        expect(Plan.invalid_or_withdrawn.first).to eq invalid
      end
    end

    describe '#unknown' do
      let!(:unknown) { create(:plan, status: 'Current status not assigned in APAS') }

      it 'retrieves only unknown plans' do
        expect(Plan.unknown.first).to eq unknown
      end
    end

    describe '#pending' do
      let!(:pending) { create(:plan, status: 'Pending') }

      it 'retrieves only pending plans' do
        expect(Plan.pending.first).to eq pending
      end
    end

    describe '#on_appeal' do
      let!(:on_appeal) { create(:plan, status: 'On Appeal') }

      it 'retrieves only plans on appeal' do
        expect(Plan.on_appeal.first).to eq on_appeal
      end
    end
  end
end
