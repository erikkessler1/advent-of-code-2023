# frozen_string_literal: true

require_relative "../day-14/parabolic_reflector_dish"

describe ParabolicReflectorDish, day: 14 do
  subject(:parabolic_reflector_dish) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        O....#....
        O.OO#....#
        .....##...
        OO.#O....O
        .O.....O#.
        O.#..O.#.#
        ..O..#O..O
        .......O..
        #....###..
        #OO..#....
      INPUT
    end

    it "finds the total load", part: 1 do
      expect(parabolic_reflector_dish.load_tilted_north).to eq(136)
    end

    it "spins", part: 2 do
      start, loads = parabolic_reflector_dish.find_spin_period
      target = (1_000_000_000 - start) % loads.size

      expect(loads[target]).to eq(64)
    end
  end

  it "finds the total load", part: 1 do
    expect(parabolic_reflector_dish.load_tilted_north).to eq(108_641)
  end

  it "spins", part: 2 do
    start, loads = parabolic_reflector_dish.find_spin_period
    target = (1_000_000_000 - start) % loads.size

    expect(loads[target]).to eq(84_328)
  end
end
