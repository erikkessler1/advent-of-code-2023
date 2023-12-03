# frozen_string_literal: true

require_relative "../day-03/gear_ratios"

describe GearRatios, day: 3 do
  subject(:engine) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
      INPUT
    end

    it "finds part numers", part: 1 do
      expect(engine.parts.map(&:number).sum).to eq(4_361)
    end

    it "finds gear ratios", part: 2 do
      expect(engine.gears.map(&:gear_ratio).sum).to eq(467_835)
    end
  end

  it "finds part numers", part: 1 do
    expect(engine.parts.map(&:number).sum).to eq(539_433)
  end

  it "finds gear ratios", part: 2 do
    expect(engine.gears.map(&:gear_ratio).sum).to eq(75_847_567)
  end
end
