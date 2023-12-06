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
      first_win = time.times.find do |i|
        i * (time - i) > distance
      end

      # I'm thinking of it as a parabola, so it will be symmetric
      # hence the `2 *` for finding ways to lose.
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
