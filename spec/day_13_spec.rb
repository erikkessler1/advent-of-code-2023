# frozen_string_literal: true

require_relative "../day-13/point_of_incidence"

describe PointOfIncidence, day: 13 do
  subject(:point_of_incidence) { described_class.new(input, smudges:) }

  let(:smudges) { 0 }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        #.##..##.
        ..#.##.#.
        ##......#
        ##......#
        ..#.##.#.
        ..##..##.
        #.#.##.#.

        #...##..#
        #....#..#
        ..##..###
        #####.##.
        #####.##.
        ..##..###
        #....#..#
      INPUT
    end

    it "finds mirrors", part: 1 do
      expect(point_of_incidence.patterns.map(&:mirror_summary).sum).to eq(405)
    end

    context "with smudges", part: 2 do
      let(:smudges) { 1 }

      it "finds mirrors", part: 2 do
        expect(point_of_incidence.patterns.map(&:mirror_summary).sum).to eq(400)
      end
    end
  end

  it "finds mirrors", part: 1 do
    expect(point_of_incidence.patterns.map(&:mirror_summary).sum).to eq(29_213)
  end

  context "with smudges", part: 2 do
    let(:smudges) { 1 }

    it "finds mirrors", part: 2 do
      expect(point_of_incidence.patterns.map(&:mirror_summary).sum).to eq(37_453)
    end
  end
end
