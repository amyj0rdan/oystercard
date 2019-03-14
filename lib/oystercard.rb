class Oystercard

  attr_reader :balance, :journeys
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1

  def initialize
      @balance = 0
      @journeys = []
  end

  def top_up(money)
    raise "Balance cannot exceed £#{MAXIMUM_BALANCE}" if @balance + money > MAXIMUM_BALANCE
      @balance += money
  end

  def touch_in(station)
    raise 'Insufficient funds' if @balance < MINIMUM_FARE
    @journeys << { entry: station }
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    if @journeys[-1][:exit] == nil
      @journeys[-1][:exit] = station
    else
      @journeys << { exit: station}
    end
  end

  def in_journey?
    @journeys == [] ? false : @journeys[-1][:exit] == nil
  end

  private

  def deduct(money)
    @balance -= money
  end

end
