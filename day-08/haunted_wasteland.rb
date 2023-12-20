# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/extensions"

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

    steps_set.least_common_multiple
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
end
