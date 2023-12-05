# frozen_string_literal: true

require_relative "../day-05/almanac"

describe Almanac, day: 5 do
  subject(:almanac) { AlmanacParser.parse(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
      INPUT
    end

    it "finds seed locations", part: 1 do
      expect(almanac.seeds.map(&:min_location).min).to eq(35)
    end

    it "finds spread seed locations", part: 2 do
      expect(almanac.seed_ranges.map(&:min_location).min).to eq(46)
    end
  end

  it "finds seed locations", part: 1 do
    expect(almanac.seeds.map(&:min_location).min).to eq(424_490_994)
  end

  it "finds spread seed locations", part: 2 do
    expect(almanac.seed_ranges.map(&:min_location).min).to eq(15_290_096)
  end
end
