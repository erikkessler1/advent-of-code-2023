# frozen_string_literal: true

require_relative "../day-02/cube_conundrum"

describe CubeConundrum, day: 2 do
  subject(:cube) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
      INPUT
    end

    it "finds valid games", part: 1 do
      expect(cube.games.select(&:valid?).map(&:id).sum).to eq(8)
    end

    it "finds the power of games", part: 2 do
      expect(cube.games.map(&:power).sum).to eq(2_286)
    end
  end

  it "finds valid games", part: 1 do
    expect(cube.games.select(&:valid?).map(&:id).sum).to eq(2_076)
  end

  it "finds the power of games", part: 2 do
    expect(cube.games.map(&:power).sum).to eq(70_950)
  end
end
