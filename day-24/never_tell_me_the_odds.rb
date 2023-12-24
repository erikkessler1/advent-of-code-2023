# frozen_string_literal: true

require_relative "../lib/newline_input"

class NeverTellMeTheOdds
  include NewlineInput

  def crosses(min:, max:)
    hailstones.size.times.map do |i|
      a = hailstones[i]
      (i + 1...hailstones.size).count do |j|
        b = hailstones[j]
        x, y = NeverTellMeTheOdds::Solver.solve(a, b)
        next if a.past?(x, y) || b.past?(x, y)

        x >= min && x <= max &&
          y >= min && y <= max
      end
    end.sum
  end

  def hailstones
    @hailstones ||= lines.map(&Hailstone.method(:new))
  end
end

class NeverTellMeTheOdds
  class Solver
    def self.solve(a, b)
      x = (a.intercept - b.intercept) / (b.slope - a.slope)
      y = (a.slope * x) + a.intercept

      [x, y]
    end
  end
end

class NeverTellMeTheOdds
  class Hailstone
    def initialize(line)
      @initial, @velocity = line.split(" @ ")
      @initial = @initial.split(", ").map(&:to_i)
      @velocity = @velocity.split(", ").map(&:to_i)
    end

    def past?(x, y)
      (x < @initial[0] && @velocity[0] >= 0) ||
        (x > @initial[0] && @velocity[0] <= 0) ||
        (y < @initial[1] && @velocity[1] >= 0) ||
        (y > @initial[1] && @velocity[1] <= 0)
    end

    def slope
      @slope ||= @velocity[1].to_f / @velocity[0]
    end

    def intercept
      @intercept ||= @initial[1] - (slope * @initial[0])
    end

    def to_s
      "y = #{slope}x + #{intercept}"
    end
  end
end
