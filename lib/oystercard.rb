class Oystercard

    attr_reader :balance, :entry_station, :exit_station, :journeys

    BALANCE_LIMIT = 90 
    MINIMUM_BALANCE = 1
    MINIMUM_FARE = 3

    def initialize
        @balance = 0
        @journeys = []
    end

    def top_up(money)
       raise "cannot top up balance over $#{BALANCE_LIMIT}" if @balance + money > BALANCE_LIMIT
       @balance += money   
    end

    def touch_in(station)
        raise "insufficient funds" if @balance < MINIMUM_BALANCE
        @entry_station = station
        @journeys << { :entry => station, :exit => nil }
    end

    def touch_out(station)
        deduct(MINIMUM_FARE)
        @exit_station = station
        @journeys[-1][:exit] = station
        @entry_station = nil
    end

    def in_journey?
        @entry_station
    end

    private

    def deduct(money)
        @balance -= money
    end

end