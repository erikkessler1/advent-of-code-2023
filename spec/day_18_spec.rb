# frozen_string_literal: true

require_relative "../day-18/lavaduct_lagoon"

describe LavaductLagoon, day: 18 do
  subject(:lavaduct_lagoon) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        R 6 (#70c710)
        D 5 (#0dc571)
        L 2 (#5713f0)
        D 2 (#d2c081)
        R 2 (#59c680)
        D 2 (#411b91)
        L 5 (#8ceee2)
        U 2 (#caa173)
        L 1 (#1b58a2)
        U 2 (#caa171)
        R 2 (#7807d2)
        U 3 (#a77fa3)
        L 2 (#015232)
        U 2 (#7a21e3)
      INPUT
    end

    it "finds the lagoon size", part: 1 do
      expect(lavaduct_lagoon.size).to eq(62)
    end

    it "finds the *correct* lagoon size", part: 1 do
      expect(lavaduct_lagoon.size(extract: true)).to eq(952_408_144_115)
    end
  end

  it "finds the lagoon size", part: 1 do
    expect(lavaduct_lagoon.size).to eq(76_387)
  end

  it "finds the *correct* lagoon size", part: 1 do
    expect(lavaduct_lagoon.size(extract: true)).to eq(250_022_188_522_074)
  end
end
