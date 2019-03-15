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

    deduct(Journey::PENALTY_FARE) if in_journey?
    @journeys << @journey_class.new(station)

  end

  def touch_out(station)
    @journeys << @journey_class.new if @journeys.empty? || @journeys[-1].complete?
    deduct(@journeys[-1].calculate_fare)
    @journeys[-1].finish(station)
  end

  def in_journey?
    @journeys == [] ? false : !@journeys[-1].complete?
  end

  private

  def deduct(money)
    @balance -= money
  end

end
