class Journey

  attr_reader :entry_station, :exit_station
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize(station = nil)
    @entry_station = station
  end

  def complete?
    !@exit_station.nil?
  end

  def finish(station)
    @exit_station = station
    return self
  end

  def calculate_fare
    @entry_station ? MINIMUM_FARE : PENALTY_FARE
  end
end
