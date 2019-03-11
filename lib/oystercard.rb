class Oystercard

    attr_reader :balance
    BALANCE_LIMIT = 90 
    MINIMUM_BALANCE = 1
    def initialize
        @balance = 0
        @in_journey = false
    end

    def top_up(money)
       raise "cannot top up balance over $#{BALANCE_LIMIT}" if @balance + money > BALANCE_LIMIT
       @balance += money   
    end

    def deduct(money)
        @balance -= money
    end

    def touch_in
        raise "insufficient funds" if @balance < MINIMUM_BALANCE
        @in_journey = true
    end

    def touch_out
        @in_journey = false
    end

    def in_journey?
        @in_journey
    end

end