require 'journey'

describe Journey do
  let(:station) { double :Station }
  let(:station2) { double :Station }

  describe '#new' do
    it 'has an incomplete journey' do
      journey = described_class.new(station)
      expect(journey).not_to be_complete
    end

    context 'passed a station argument' do
      it 'checks for the station' do
        journey = described_class.new(station)
        expect(journey.entry_station).to eq station
      end
    end

    context 'not passed a station argument' do
      it "doesn't have an entry station" do
        # stuff in here
      end
    end
  end

  describe '#finish' do
    it 'logs the exit station' do
      journey = described_class.new(station)
      journey.finish(station2)
      expect(journey.exit_station).to eq station2
    end

    it 'changes the journey status to complete' do
      journey = described_class.new(station)
      journey.finish(station2)
      expect(journey).to be_complete
    end
  end

  describe '#calculate_fare' do
    context 'in journey' do

      it 'charges the minimum fare when touching out' do
        journey = described_class.new(station)
        journey.finish(station2)
        expect(journey.calculate_fare).to eq Journey::MINIMUM_FARE
      end

    end

    context 'not in journey' do

      it 'charges the penalty fare when touching out' do
        journey = described_class.new
        journey.finish(station2)
        expect(journey.calculate_fare).to eq Journey::PENALTY_FARE
      end
    end
  end

end
