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

  describe '#recently_registered' do
    it 'includes plans with registration_dates within the last month' do
      recent = create(:plan, registration_date: 2.weeks.ago.to_date)
      old    = create(:plan, registration_date: 2.months.ago.to_date)

      expect(Plan.recently_registered).to eq ([recent])
    end
  end

  describe '#recently_decided' do
    it 'includes plans with decision_dates within the last month' do
      recent = create(:plan, decision_date: 2.weeks.ago.to_date)
      old    = create(:plan, decision_date: 2.months.ago.to_date)

      expect(Plan.recently_decided).to eq ([recent])
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

  describe '.persist' do
    describe 'for a new planning reference' do
      let(:plan) do
        double('observed_plan',
          planning_reference: 'abc/123',
          description: 'description',
          location: 'location',
          lat: 1,
          long: 2,
          current_status: 'pending',
          more_information: 'info',
          registration_date: '2017-03-08',
          decision_date: '2017-03-08'
        )
      end

      it 'creates a new record' do
        expect {
          Plan.persist(plan)
        }.to change { Plan.count }.from(0).to(1)
      end

      it 'will not create an audit record' do
        expect {
          Plan.persist(plan).not_to change { Audited::Audit.count }
        }
      end
    end
  end

  describe 'for an existing planning reference' do
    let!(:existing) { create(:plan) }

    describe 'when there are no changes' do
      let(:plan) do
        double('observed_plan',
          planning_reference: existing.reference,
          description: existing.description,
          location: existing.address,
          current_status: existing.status,
          more_information: existing.more_info_link,
          registration_date: existing.registration_date,
          decision_date: existing.decision_date,
          lat: existing.location.coordinates[0],
          long: existing.location.coordinates[1]
        )
      end

      it 'will not update the record' do
        expect {
          Plan.persist(plan)
        }.not_to change { Plan.count }
      end

      it 'will not create an audit record' do
        expect {
          Plan.persist(plan)
        }.not_to change { Audited::Audit.count }
      end
    end

    describe 'when there are changes' do
      let(:plan) do
        double('observed_plan_with_changes',
          planning_reference: existing.reference,
          description: existing.description,
          location: existing.address,
          current_status: 'New Status',
          more_information: existing.more_info_link,
          registration_date: existing.registration_date,
          decision_date: existing.decision_date,
          lat: existing.location.coordinates[0],
          long: existing.location.coordinates[1]
        )
      end

      it 'will update the record' do
        expect {
          Plan.persist(plan)
        }.not_to change { Plan.count }

        updated_plan = Plan.where(reference: existing.reference).first
        expect(updated_plan.status).to eq 'New Status'
      end

      it 'will create an audit record' do
        expect {
          Plan.persist(plan)
        }.to change { Audited::Audit.count }.from(0).to(1)

        updated_plan = Plan.where(reference: existing.reference).first
        expect(updated_plan.audits.last.audited_changes.keys).to eq ['status']
      end
    end
  end
end
