require 'oystercard'

describe Oystercard do 
    let(:entry_station) {double :entry_station}

    describe ':balance' do
    
        it 'has a balance of 0 when initialized' do
            expect(subject.balance).to eq 0
        end

    end

    context 'card has been topped up' do

        before(:each) do
            subject.top_up(Oystercard::BALANCE_LIMIT)
        end

        it 'adds money to the card' do
            expect(subject.balance).to eq Oystercard::BALANCE_LIMIT
        end

        # private method so commented this test out
        # it 'deducts money from card' do 
        #     expect { subject.deduct 10 }.to change{ subject.balance }.by -10
        # end 

        it 'raises an error when over balance limit' do 
            expect{subject.top_up(1)}.to raise_error "cannot top up balance over $#{Oystercard::BALANCE_LIMIT}"
        end 




    end

    describe '#in_journey?' do

        it 'is not in_journey for a new card' do
            expect(subject).not_to be_in_journey
        end

    end

    context 'card has been touched in and balance greater than minimum' do

        before(:each) do
            subject.top_up(Oystercard::BALANCE_LIMIT)
            subject.touch_in(entry_station)
        end 
        
        it 'is in journey after touched in' do
            expect(subject).to be_in_journey
        end

        it 'is not in journey after touching out' do
            subject.touch_out
            expect(subject).not_to be_in_journey
        end

        it 'forgets the entry station on touching out' do 
            subject.touch_out
            expect(subject.entry_station).to eq nil
        end 

        it 'reduces the balance by the minimum fare' do
            expect { subject.touch_out}. to change { subject.balance }.by -Oystercard::MINIMUM_FARE
        end

        it 'remember the entry station when touched in' do 
            expect(subject.entry_station).to eq entry_station
        end


    end

    context 'card below minimum balance' do 

        it 'raises error when trying to touch in' do
        expect{subject.touch_in(entry_station)}.to raise_error 'insufficient funds'
        end 

    end 

end 