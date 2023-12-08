# frozen_string_literal: true

require_relative "../day-08/haunted_wasteland"

describe HauntedWasteland, day: 8 do
  subject(:haunted_wasteland) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        LLR

        AAA = (BBB, BBB)
        BBB = (AAA, ZZZ)
        ZZZ = (ZZZ, ZZZ)
      INPUT
    end

    it "finds how longs it takes to reach ZZZ", part: 1 do
      expect(haunted_wasteland.steps(to: "ZZZ")).to eq(6)
    end
  end

  context "with ghost sample input", sample: true do
    let(:input) do
      <<~INPUT
        LR

        11A = (11B, XXX)
        11B = (XXX, 11Z)
        11Z = (11B, XXX)
        22A = (22B, XXX)
        22B = (22C, 22C)
        22C = (22Z, 22Z)
        22Z = (22B, 22B)
        XXX = (XXX, XXX)
      INPUT
    end

    it "finds how longs it takes to reach Zs", part: 2 do
      expect(haunted_wasteland.steps(from: "..A", to: "..Z")).to eq(6)
    end
  end

  it "finds how longs it takes to reach ZZZ", part: 1 do
    expect(haunted_wasteland.steps(to: "ZZZ")).to eq(20_093)
  end

  it "finds how longs it takes to reach Zs", part: 2 do
    expect(haunted_wasteland.steps(from: "..A", to: "..Z")).to eq(22_103_062_509_257)
  end
end
