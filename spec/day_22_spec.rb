# frozen_string_literal: true

require_relative "../day-22/sand_slabs"

describe SandSlabs, day: 22 do
  subject(:sand_slabs) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        1,0,1~1,2,1
        0,0,2~2,0,2
        0,2,3~2,2,3
        0,0,4~0,2,4
        2,0,5~2,2,5
        0,1,6~2,1,6
        1,1,8~1,1,9
      INPUT
    end

    it "find bricks that can be disintegrated", part: 1 do
      expect(sand_slabs.bricks.filter(&:can_disintergrate?).size).to eq(5)
    end

    it "find the chain", part: 2 do
      expect(sand_slabs.bricks.map(&:holding).sum).to eq(7)
    end
  end

  it "find bricks that can be disintegrated", part: 1 do
    expect(sand_slabs.bricks.filter(&:can_disintergrate?).size).to eq(375)
  end

  it "find the chain", part: 2 do
    expect(sand_slabs.bricks.map(&:holding).sum).to eq(72_352)
  end
end
