# frozen_string_literal: true

require_relative "../day-10/pipe_maze"

describe PipeMaze, day: 10 do
  subject(:pipe_maze) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        ..F7.
        .FJ|.
        SJ.L7
        |F--J
        LJ...
      INPUT
    end

    it "finds the loop's size", part: 1 do
      expect(pipe_maze.loop.size / 2).to eq(8)
    end
  end

  context "with more sample input", sample: true do
    let(:input) do
      <<~INPUT
        FF7FSF7F7F7F7F7F---7
        L|LJ||||||||||||F--J
        FL-7LJLJ||||||LJL-77
        F--JF--7||LJLJIF7FJ-
        L---JF-JLJIIIIFJLJJ7
        |F|F-JF---7IIIL7L|7|
        |FFJF7L7F-JF7IIL---7
        7-L-JL7||F7|L7F-7F7|
        L.L7LFJ|||||FJL7||LJ
        L7JLJL-JLJLJL--JLJ.L
      INPUT
    end

    it "finds the enclosed tiles", part: 2 do
      pipe_maze.expand!
      pipe_maze.fill!
      expect(pipe_maze.count { |_, value| value == "." } / 9).to eq(10)
    end
  end

  context "with even more sample input", sample: true do
    let(:input) do
      <<~INPUT
        ..........
        .S------7.
        .|F----7|.
        .||OOOO||.
        .||OOOO||.
        .|L-7F-J|.
        .|II||II|.
        .L--JL--J.
        ..........
      INPUT
    end

    it "finds the enclosed tiles", part: 2 do
      pipe_maze.expand!
      pipe_maze.fill!
      expect(pipe_maze.count { |_, value| value == "." } / 9).to eq(4)
    end
  end

  it "finds the loop's size", part: 1 do
    expect(pipe_maze.loop.size / 2).to eq(7_102)
  end

  it "finds the enclosed tiles", part: 2 do
    pipe_maze.expand!
    pipe_maze.fill!
    expect(pipe_maze.count { |_, value| value == "." } / 9).to eq(363)
  end
end
