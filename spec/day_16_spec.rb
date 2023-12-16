# frozen_string_literal: true

require_relative "../day-16/cave"

describe Cave, day: 16 do
  subject(:cave) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      # I was struggling with the escaping, so I pasted the sample in
      # a file and did `puts File.read(...).dump`. Ugh.
      ".|...\\....\n|.-.\\.....\n.....|-...\n........|.\n..........\n.........\\\n" \
        "..../.\\\\..\n.-.-/..|..\n.|....-|.\\\n..//.|....\n"
    end

    it "finds energized tiles", part: 1 do
      expect(cave.beam!).to eq(46)
    end

    it "finds the best start", part: 2 do
      expect(cave.map { |start| cave.beam!(start) }.max).to eq(51)
    end
  end

  it "finds energized tiles", part: 1 do
    expect(cave.beam!).to eq(7_482)
  end

  it "finds the best start", part: 2 do
    expect(cave.map { |start| cave.beam!(start) }.max).to eq(7_896)
  end
end
