class Oystercard

    attr_reader :balance, :entry_station

    BALANCE_LIMIT = 90 
    MINIMUM_BALANCE = 1
    MINIMUM_FARE = 3

    def initialize
        @balance = 0
        @in_journey = false
    end

    def top_up(money)
       raise "cannot top up balance over $#{BALANCE_LIMIT}" if @balance + money > BALANCE_LIMIT
       @balance += money   
    end

    def touch_in(entry_station)
        raise "insufficient funds" if @balance < MINIMUM_BALANCE
        @in_journey = true
        @entry_station = entry_station
    end

    def touch_out
        deduct(MINIMUM_FARE)
        @in_journey = false
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