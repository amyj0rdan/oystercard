class Oystercard

  attr_reader :balance, :journeys
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1

  def initialize(journey_class = Journey)
    @balance = 0
    @journey_class = journey_class
    @journeys = []
  end

  def top_up(money)
    raise "Balance cannot exceed £#{MAXIMUM_BALANCE}" if @balance + money > MAXIMUM_BALANCE

    @balance += money
  end

  def touch_in(station)
    raise 'Insufficient funds' if @balance < MINIMUM_FARE

    @journeys << @journey_class.new(station)
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    if !@journeys[-1].complete?
      @journeys[-1].finish(station)
    else
      @journeys << @journey_class.new.finish(station)
    end
  end

  def in_journey?
    @journeys == [] ? false : !@journeys[-1].complete?
  end

  private

  def deduct(money)
    @balance -= money
  end

end
