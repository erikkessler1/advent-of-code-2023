# frozen_string_literal: true

require_relative "../day-21/step_counter"

describe StepCounter, day: 21 do
  subject(:step_counter) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        ...........
        .....###.#.
        .###.##..#.
        ..#.#...#..
        ....#.#....
        .##..S####.
        .##..#...#.
        .......##..
        .##.#.####.
        .##..##.##.
        ...........
      INPUT
    end

    it "finds visitable plots", part: 1 do
      step_counter.step!(steps: 7)
      expect(step_counter.visited[6].size).to eq(16)
    end
  end

  it "finds visitable plots", part: 1 do
    step_counter.step!(steps: 65)
    expect(step_counter.visited[64].size).to eq(3_671)
  end

  # I needed lots of hints for this part :(
  it "finds visitable plots", part: 2, slow: true do
    step_counter.step!(steps: 328, infinite: true)

    expect(step_counter.visited[65].size).to eq(3_770)
    expect(step_counter.visited[65 + 131].size).to eq(33_665)
    expect(step_counter.visited[65 + (2 * 131)].size).to eq(93_356)

    samples = [
      step_counter.visited[65].size,
      step_counter.visited[65 + 131].size,
      step_counter.visited[65 + (2 * 131)].size
    ]
    a = (samples[2] + samples[0] - (2 * samples[1])) / 2
    b = samples[1] - samples[0] - a
    c = samples[0]
    total_steps = 26_501_365
    n = total_steps / 131

    result = (a * (n**2)) + (b * n) + c
    expect(result).to eq(609_708_004_316_870)
  end
end
