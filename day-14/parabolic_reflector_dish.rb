# frozen_string_literal: true

require_relative "../lib/newline_input"

class ParabolicReflectorDish
  include NewlineInput

  def load_tilted_north
    (0...lines[0].size).map do |x|
      current_load = lines.size

      (0...lines.size).map do |y|
        value = lines[y][x]
        case value
        when "."
          0
        when "#"
          current_load = (lines.size - y) - 1
          0
        when "O"
          current_load.tap do
            current_load -= 1
          end
        end
      end.sum
    end.sum
  end

  def find_spin_period
    current_load = beam_load
    times_spun = 0
    loads = []

    min_load, min_at = loop do
      spin!
      times_spun += 1
      next_load = beam_load

      if next_load > current_load
        loads << current_load
        loads << next_load
        break [current_load, times_spun - 1]
      end

      current_load = next_load
    end

    loop do
      spin!
      next_load = beam_load
      break if next_load == min_load

      loads << next_load
    end

    [min_at, loads]
  end

  private

  def spin!
    # NORTH
    (0...lines[0].size).each do |x|
      current_load = 0

      (0...lines.size).each do |y|
        value = lines[y][x]
        case value
        when "#"
          current_load = y + 1
        when "O"
          lines[y][x] = "."
          lines[current_load][x] = "O"
          current_load += 1
        end
      end
    end

    # WEST
    (0...lines.size).each do |y|
      current_load = 0

      (0...lines[0].size).each do |x|
        value = lines[y][x]
        case value
        when "#"
          current_load = x + 1
        when "O"
          lines[y][x] = "."
          lines[y][current_load] = "O"
          current_load += 1
        end
      end
    end

    # SOUTH
    (0...lines[0].size).each do |x|
      current_load = lines.size - 1

      (0...lines.size).each do |y|
        y = (lines.size - 1) - y
        value = lines[y][x]
        case value
        when "#"
          current_load = y - 1
        when "O"
          lines[y][x] = "."
          lines[current_load][x] = "O"
          current_load -= 1
        end
      end
    end

    # EAST
    (0...lines.size).each do |y|
      current_load = lines[0].size - 1

      (0...lines[0].size).each do |x|
        x = (lines[0].size - 1) - x
        value = lines[y][x]
        case value
        when "#"
          current_load = x - 1
        when "O"
          lines[y][x] = "."
          lines[y][current_load] = "O"
          current_load -= 1
        end
      end
    end
  end

  def beam_load
    lines.map.with_index { |l, i| l.count("O") * (lines.size - i) }.sum
  end
end
