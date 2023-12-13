# frozen_string_literal: true

require_relative "../lib/newline_input"

class PointOfIncidence
  attr_reader :patterns

  attr_accessor :smudges

  def initialize(input, smudges: 0)
    @patterns = input.split("\n\n").map do |lines|
      PointOfIncidence::Pattern.new(lines, smudges:)
    end
  end
end

class PointOfIncidence
  class Pattern
    include NewlineInput

    attr_reader :expected_smudges

    def initialize(lines, smudges: 0)
      super(lines)
      @expected_smudges = smudges
    end

    def mirror_summary
      vertical_mirror = (1..max_x).find { vertical_mirror?(_1) } || 0
      horizontal_mirror = (1..max_y).find { horizontal_mirror?(_1) } || 0

      (100 * horizontal_mirror) + vertical_mirror
    end

    private

    def vertical_mirror?(x)
      smudges = []

      (0..max_y).all? do |y|
        delta = 0

        loop do
          left_x = x - (delta + 1)
          right_x = x + delta
          break true if left_x.negative? || right_x > max_x

          left = lines[y][left_x]
          right = lines[y][right_x]
          smudges << y if left != right
          break false if smudges.size > expected_smudges

          delta += 1
        end
      end && smudges.size == expected_smudges
    end

    def horizontal_mirror?(y)
      smudges = []

      (0..max_x).all? do |x|
        delta = 0

        loop do
          top_y = y - (delta + 1)
          bottom_y = y + delta
          break true if top_y.negative? || bottom_y > max_y

          top = lines[top_y][x]
          bottom = lines[bottom_y][x]
          smudges << x if top != bottom
          break false if smudges.size > expected_smudges

          delta += 1
        end
      end && smudges.size == expected_smudges
    end

    def max_x
      lines[0].size - 1
    end

    def max_y
      lines.size - 1
    end
  end
end
