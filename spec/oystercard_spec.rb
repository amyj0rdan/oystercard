require 'oystercard'

describe Oystercard do 

    describe ':balance' do
    
        it 'has a balance of 0 when initialized' do
            expect(subject.balance).to eq 0
        end

    end

    describe '#top_up' do

        it 'adds money to the card' do
            subject.top_up(10)
            expect(subject.balance).to eq 10
        end

        it 'raises an error when over balance limit' do 
            expect{subject.top_up(100)}.to raise_error "cannot top up balance over $#{Oystercard::BALANCE_LIMIT}"
        end 
    end

    describe '#deduct' do 

        it 'deducts money from card' do 
            subject.top_up(20)
            subject.deduct(10)
            expect(subject.balance).to eq 10
        end 
    end 



end 