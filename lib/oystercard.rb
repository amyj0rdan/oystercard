class Oystercard

    attr_reader :balance
    BALANCE_LIMIT = 90 
    def initialize
        @balance = 0
    end

    def top_up(money)
       raise "cannot top up balance over $#{BALANCE_LIMIT}" if @balance + money > BALANCE_LIMIT
       @balance += money   
    end

    def deduct(money)
        @balance -= money
    end

end