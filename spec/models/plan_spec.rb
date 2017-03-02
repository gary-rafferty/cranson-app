require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'validations' do
    let(:plan) { build(:plan) }

    describe 'presence of required attrs' do
      %w{status description reference location reference registration_date address}.each do |attr|
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

    describe '#within_kilometres_of' do
      let(:sphere)  { RGeo::Geographic.spherical_factory(srid: 4326) }
      let(:spire)   { [ 53.3504715, -6.2620188 ] }

      it 'includes all records within specified distance' do
        gpo = create(:plan, location: "POINT(53.349988 -6.2610747)")

        expect(Plan.within_kilometres_of(1, spire)).to eq [ gpo ]

        source = sphere.point(*spire)
        destination = gpo.location
        distance_in_metres = sphere.line(source, destination).length

        expect(distance_in_metres).to be < 1000
      end

      it 'rejects all records not within specified distance' do
        storehouse = create(:plan, location: "POINT(53.3428383 -6.2907724)")

        expect(Plan.within_kilometres_of(1, spire)).to eq [ ]

        source = sphere.point(*spire)
        destination = storehouse.location
        distance_in_metres = sphere.line(source, destination).length

        expect(distance_in_metres).to be > 1000
      end
    end
  end

  describe 'searching' do
    let!(:hit) { create(:plan, address: 'Dublin Road') }
    let!(:miss){ create(:plan, address: 'Malahide Road') }

    it 'exposes a search_by_address method' do
      expect(Plan).to respond_to(:search_by_address)
    end

    it 'hits on address matches' do
      expect(Plan.search_by_address('dublin').count).to eq 1
    end
  end
end
