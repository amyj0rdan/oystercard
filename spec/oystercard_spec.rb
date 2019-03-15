require 'oystercard'

describe Oystercard do

  subject { described_class.new(journey_class) }

  let(:station) { double :station }
  let(:station2) { double :station }
  let(:journey) { double :journey }
  let(:journey_class) { double :journey_class }

  describe '#initialize' do

    it 'has a balance of 0' do
      expect(subject.balance).to eq 0
    end

    it 'has no journeys' do
      expect(subject.journeys).to be_empty
    end

  end

  describe '#top_up' do

    it 'adds money to the card' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect(subject.balance).to eq Oystercard::MAXIMUM_BALANCE
    end

    it 'raises exception when balance would go above maximum' do
      expect { subject.top_up(Oystercard::MAXIMUM_BALANCE + 1) }.to raise_error 'Balance cannot exceed £90'
    end
  end

  describe '#in_journey?' do

    it 'should return false if oystercard has just been created' do
      expect(subject).not_to be_in_journey
    end

  end

  describe '#touch_in' do

    it 'charges penalty fare when touched in when still in journey' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      allow(journey_class).to receive(:new).with(station).and_return journey
      allow(journey).to receive(:complete?).and_return false
      allow(journey).to receive(:calculate_fare)
      subject.touch_in(station)
      allow(journey).to receive(:calculate_fare).and_return 6
      expect { subject.touch_in(station) }.to change { subject.balance }.by(-6)

    end
    it 'should be in journey when touched in' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      allow(journey_class).to receive(:new).with(station).and_return journey
      allow(journey).to receive(:complete?).and_return false
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end

    it 'should raise an error if balance is zero' do
      expect { subject.touch_in(station) }.to raise_error 'Insufficient funds'
    end

    it 'should raise an error if less than minimum balance' do
      subject.top_up(0.5)
      expect { subject.touch_in(station) }.to raise_error 'Insufficient funds'
    end

    it 'create a new journey' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect(journey_class).to receive(:new).with(station).and_return journey
      subject.touch_in(station)
    end

    it 'stores the journey' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      allow(journey_class).to receive(:new).with(station).and_return journey
      subject.touch_in(station)
      expect(subject.journeys).to include journey
    end

  end

  describe '#touch_out' do

    before(:each) do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      allow(journey_class).to receive(:new).with(station).and_return journey
      allow(journey_class).to receive(:new).with(no_args).and_return journey
      allow(journey).to receive(:finish).with(station).and_return journey
      allow(journey).to receive(:calculate_fare).and_return 1
    end

    context 'the user has never touched in' do
      it 'creates a new journey' do
        expect(journey_class).to receive(:new).with(no_args)
        subject.touch_out(station)
      end
      it 'and stores it' do
        subject.touch_out(station)
        expect(subject.journeys[-1]).to eq journey
      end
    end

    context "user has touched in" do
      before :each do
        allow(journey).to receive(:complete?).and_return false
        subject.touch_in(station)
      end

      it 'finishes the journey' do
        expect(journey).to receive(:finish).with(station2)
        subject.touch_out(station2)
      end

      it 'should reduce balance by minimum fare' do
        allow(journey).to receive(:finish)
        expect { subject.touch_out(station2) }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
      end

      context "... and touched out" do
        before(:each) do
          allow(journey).to receive(:complete?).and_return true
          allow(journey).to receive(:finish).with(station).and_return journey
          allow(journey).to receive(:calculate_fare).and_return 6
          subject.touch_out(station)
        end

        it 'creates a new journey' do
          expect(journey_class).to receive(:new).with(no_args)
          subject.touch_out(station)
        end

        it '... and finishes it' do
          expect(journey).to receive(:finish).with(station)
          subject.touch_out(station)
        end

        it '... and stores the journey' do
          subject.touch_out(station)
          expect(subject.journeys[-1]).to eq journey
        end

        it '... and charges the penalty fare' do
          allow(journey).to receive(:calculate_fare).and_return 6
          expect { subject.touch_out(station) }.to change { subject.balance }.by(-6)
        end
      end

    end

  end

end
