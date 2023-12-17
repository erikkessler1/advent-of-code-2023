# frozen_string_literal: true

require_relative "../day-17/clumsy_crucible"

describe ClumsyCrucible, day: 17 do
  subject(:clumsy_crucible) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        2413432311323
        3215453535623
        3255245654254
        3446585845452
        4546657867536
        1438598798454
        4457876987766
        3637877979653
        4654967986887
        4564679986453
        1224686865563
        2546548887735
        4322674655533
      INPUT
    end

    it "finds heat loss", part: 1 do
      expect(clumsy_crucible.min_heat_loss).to eq(102)
    end

    context "with an ultra crucible" do
      subject(:clumsy_crucible) { UltraCrucible.new(input) }

      it "finds heat loss", part: 2 do
        expect(clumsy_crucible.min_heat_loss).to eq(94)
      end
    end
  end

  it "finds heat loss", part: 1, slow: true do
    expect(clumsy_crucible.min_heat_loss).to eq(855)
  end

  context "with an ultra crucible" do
    subject(:clumsy_crucible) { UltraCrucible.new(input) }

    it "finds heat loss", part: 2, slow: true do
      expect(clumsy_crucible.min_heat_loss).to eq(980)
    end
  end
end
