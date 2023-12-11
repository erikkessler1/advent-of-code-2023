# frozen_string_literal: true

require_relative "../day-11/cosmic_expansion"

describe CosmicExpansion, day: 11 do
  subject(:cosmic_expansion) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        ...#......
        .......#..
        #.........
        ..........
        ......#...
        .#........
        .........#
        ..........
        .......#..
        #...#.....
      INPUT
    end

    it "finds the shortest paths" do
      cosmic_expansion.expand!
      expect(cosmic_expansion.galaxy_pairs.map(&:shortest_path).sum).to eq(374)

      cosmic_expansion.expand!(10)
      expect(cosmic_expansion.galaxy_pairs.map(&:shortest_path).sum).to eq(1_030)

      cosmic_expansion.expand!(100)
      expect(cosmic_expansion.galaxy_pairs.map(&:shortest_path).sum).to eq(8_410)
    end
  end

  it "finds the shortest paths", slow: true do
    cosmic_expansion.expand!
    expect(cosmic_expansion.galaxy_pairs.map(&:shortest_path).sum).to eq(9_957_702)

    cosmic_expansion.expand!(1_000_000)
    expect(cosmic_expansion.galaxy_pairs.map(&:shortest_path).sum).to eq(512_240_933_238)
  end
end
