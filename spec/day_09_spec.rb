# frozen_string_literal: true

require_relative "../day-09/mirage_maintenance"

describe MirageMaintenance, day: 9 do
  subject(:mirage_maintenance) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        0 3 6 9 12 15
        1 3 6 10 15 21
        10 13 16 21 30 45
      INPUT
    end

    it "finds extrapolated values" do
      mirage_maintenance.predict!
      expect(mirage_maintenance.histories.map(&:last).sum).to eq(114)
      expect(mirage_maintenance.histories.map(&:first).sum).to eq(2)
    end
  end

  it "finds extrapolated values" do
    mirage_maintenance.predict!
    expect(mirage_maintenance.histories.map(&:last).sum).to eq(1_974_232_246)
    expect(mirage_maintenance.histories.map(&:first).sum).to eq(928)
  end
end
