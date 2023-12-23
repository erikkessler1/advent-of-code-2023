# frozen_string_literal: true

require_relative "../day-23/a_long_walk"

describe ALongWalk, day: 23 do
  subject(:a_long_walk) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        #.#####################
        #.......#########...###
        #######.#########.#.###
        ###.....#.>.>.###.#.###
        ###v#####.#v#.###.#.###
        ###.>...#.#.#.....#...#
        ###v###.#.#.#########.#
        ###...#.#.#.......#...#
        #####.#.#.#######.#.###
        #.....#.#.#.......#...#
        #.#####.#.#.#########v#
        #.#...#...#...###...>.#
        #.#.#v#######v###.###v#
        #...#.>.#...>.>.#.###.#
        #####v#.#.###v#.#.###.#
        #.....#...#...#.#.#...#
        #.#########.###.#.#.###
        #...###...#...#...#.###
        ###.###.#.###v#####v###
        #...#...#.#.>.>.#.>.###
        #.###.###.#.###.#.#v###
        #.....###...###...#...#
        #####################.#
      INPUT
    end

    it "finds the longest walk", part: 1 do
      expect(a_long_walk.longest_hike).to eq(94)
    end

    it "finds the dry longest walk", part: 2 do
      expect(a_long_walk.longest_hike(dry: true)).to eq(154)
    end
  end

  it "finds the longest walk", part: 1 do
    expect(a_long_walk.longest_hike).to eq(2_074)
  end

  it "finds the dry longest walk", part: 2, slow: true do
    expect(a_long_walk.longest_hike(dry: true)).to eq(64_94)
  end
end
