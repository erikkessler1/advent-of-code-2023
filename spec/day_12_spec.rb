# frozen_string_literal: true

require_relative "../day-12/hot_springs"

describe HotSprings, day: 12 do
  subject(:hot_springs) { described_class.new(input) }

  context "with my sample input", sample: true do
    let(:input) do
      <<~INPUT
        ???.### 1,1,3
        .??..??...?##. 1,1,3
        ?#?#?#?#?#?#?#? 1,3,1,6
        ????.#...#... 4,1,1
        ????.######..#####. 1,6,5
        ?###???????? 3,2,1
      INPUT
    end

    it "finds possible arrangements", part: 1 do
      expect(hot_springs.map(&:possible_arrangements).sum).to eq(21)

      hot_springs.unfold!(5)
      expect(hot_springs.map(&:possible_arrangements).sum).to eq(525_152)
    end
  end

  it "finds possible arrangements", part: 1 do
    expect(hot_springs.map(&:possible_arrangements).sum).to eq(7_251)

    hot_springs.unfold!(5)
    expect(hot_springs.map(&:possible_arrangements).sum).to eq(2_128_386_729_962)
  end
end
