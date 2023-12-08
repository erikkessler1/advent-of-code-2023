# frozen_string_literal: true

require_relative "../lib/newline_input"

class HauntedWasteland
  include NewlineInput

  def steps(to:, from: "AAA")
    froms = moves.keys.grep(/#{from}/)
    steps_set = froms.map do |location|
      steps = 0
      current = location

      until current.match?(/#{to}/)
        direction = directions[steps % directions.size]
        move = moves[current]

        current = move[direction]
        steps += 1
      end

      steps
    end

    least_common_multiple(steps_set)
  end

  private

  def directions
    @directions ||= lines[0].each_char.map do |direction|
      case direction
      when "L"
        0
      when "R"
        1
      else
        raise "Not a direction: #{direction}"
      end
    end
  end

  def moves
    @moves ||= lines.drop(2).to_h do |line|
      source, *destinations = line.match(/(...) = \((...), (...)\)/).captures
      [source, destinations]
    end
  end

  def least_common_multiple(steps_set)
    steps_set.map do |steps|
      prime_factors(steps).tally
    end.reduce do |factor_tally, other_factor_tally|
      factor_tally.merge(other_factor_tally) do |_, *conflict|
        conflict.max
      end
    end.keys.reduce(&:*)
  end

  def prime_factors(n)
    factors = []

    while n.even?
      factors << 2
      n /= 2
    end

    i = 3
    max = Math.sqrt(n)
    until i > max
      while (n % i).zero?
        factors << i
        n /= i
      end
      i += 2
    end

    factors << n if n > 2

    factors
  end
end
