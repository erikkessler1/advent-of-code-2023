# frozen_string_literal: true

class WaitForIt
  def initialize(input)
    ints = input.split.map do |int|
      Integer(int)
    rescue ArgumentError
      nil
    end.compact

    @races = ints[0...ints.size / 2].zip(ints[ints.size / 2...])
  end

  def ways_to_win
    @races.map do |(time, distance)|
      # Solve quadratic for the first intersection:
      #   x(t - x) = d
      #   -x^2 + tx - d = 0
      neg_b = -1 * time
      sqrt = Math.sqrt((time**2) - (4 * (distance + 1)))  # + 1 because we need to beat it
      ac = -2

      first_win = ((neg_b + sqrt) / ac).ceil

      total_ways = time + 1
      ways_to_lose = 2 * first_win

      total_ways - ways_to_lose
    end
  end

  def join!
    @races = @races.reduce(["", ""]) do |(joined_time, joined_distance), (time, distance)|
      ["#{joined_time}#{time}", "#{joined_distance}#{distance}"]
    end.then { |(time, distance)| [[Integer(time), Integer(distance)]] }
  end
end
