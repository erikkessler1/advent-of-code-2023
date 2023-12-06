# frozen_string_literal: true

require_relative "../day-06/wait_for_it"

describe WaitForIt, day: 6 do
  subject(:wait_for_it) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        Time:      7  15   30
        Distance:  9  40  200
      INPUT
    end

    it "finds ways to win", part: 1 do
      expect(wait_for_it.ways_to_win.reduce(&:*)).to eq(288)
    end

    it "finds ways to win the joined game", part: 2 do
      wait_for_it.join!
      expect(wait_for_it.ways_to_win.reduce(&:*)).to eq(71_503)
    end
  end

  it "finds ways to win", part: 1 do
    expect(wait_for_it.ways_to_win.reduce(&:*)).to eq(2_756_160)
  end

  it "finds ways to win the joined game", part: 2 do
    wait_for_it.join!
    expect(wait_for_it.ways_to_win.reduce(&:*)).to eq(34_788_142)
  end
end
