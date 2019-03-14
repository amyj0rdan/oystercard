require 'station'

describe Station do
  describe '#new' do
    it "records the station name" do
      station = described_class.new("victoria", 1)
      expect(station.name).to eq "victoria"
    end

    it 'records the zone' do
      station = described_class.new("Aldgate East", 1)
      expect(station.zone).to eq 1
    end
  end
end
