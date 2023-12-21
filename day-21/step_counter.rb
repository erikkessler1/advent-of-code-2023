# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/point"

class StepCounter
  include NewlineInput

  def size
    lines.size
  end

  def step!(steps:, point: start_point, taken: 0, infinite: false)
    return 0 if visited[taken].include?(point)
    return 1 if taken == steps

    visited[taken] << point

    adjacent_points(point, infinite) do |next_point|
      next if lines[next_point.y % lines.size][next_point.x % lines.size] == "#"

      step!(steps:, point: next_point, taken: taken + 1, infinite:)
    end
  end

  def visited
    @visited ||= Hash.new do |hash, step|
      hash[step] = Set.new
    end
  end

  def adjacent_points(point, infinite)
    x = point.x
    y = point.y

    yield Point.new(x + 1, y) if infinite || x < lines[0].size - 1
    yield Point.new(x - 1, y) if infinite || x.positive?
    yield Point.new(x, y + 1) if infinite || y < lines.size - 1
    yield Point.new(x, y - 1) if infinite || y.positive?
  end

  def start_point
    lines.each_with_index do |line, y|
      line.each_char.with_index do |plot, x|
        return Point.new(x, y) if plot == "S"
      end
    end
  end
end
