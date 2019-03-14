require 'oystercard'

describe Oystercard do

  let(:station) { double :station }
  let(:station2) { double :station }

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

      it 'should be in journey when touched in' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
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

      it 'should store entry station' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(station)
        expect(subject.journeys[-1][:entry]).to eq station
      end

      it 'should create a new journey with no exit station' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(station)
        expect(subject.journeys[-1][:exit]).to eq nil
      end

    end

    describe '#touch_out' do

      before(:each) do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(station)
      end

      it 'should not be in journey after touched out' do
        subject.touch_out(station2)
        expect(subject).not_to be_in_journey
      end

      it 'should reduce balance by minimum fare' do
        expect { subject.touch_out(station2) }.to change{subject.balance}.by(-Oystercard::MINIMUM_FARE)
      end

      # it 'should not have an entry station after touched out' do
      #   subject.touch_out(station2)
      #   expect(subject.entry_station).to eq nil
      # end

      it 'should store exit station' do
        subject.touch_out(station2)
        expect(subject.journeys[-1][:exit]).to eq station2
      end

      context 'touching out twice' do
        it 'logs the exit station' do
          subject.touch_out(station)
          subject.touch_out(station2)
          expect(subject.journeys[-1][:exit]).to eq station2
        end
        it 'last journey has no entry station' do
          subject.touch_out(station)
          subject.touch_out(station2)
          expect(subject.journeys[-1][:entry]).to be_nil
        end
      end

    end

    describe '#store_journey' do

      before(:each) do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(station)
      end

      it 'stores the entry and exit station when touching out' do
        subject.touch_out(station2)
        expect(subject.journeys).to eq [ {entry: station, exit: station2} ]
      end
    end

end
