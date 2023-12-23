# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/point"

class ALongWalk
  include NewlineInput

  def longest_hike(dry: false)
    start_x = lines.first.each_char.to_a.index(".")
    end_x = lines.last.each_char.to_a.index(".")

    start_point = Point.new(start_x, 0)
    end_point = Point.new(end_x, lines.size - 2)

    _longest_hike(point: start_point, goal: end_point, dry:) + 1
  end

  private

  def _longest_hike(point:, goal:, dry:, dist: 0, seen: Set.new)
    return dist if point == goal
    return 0 if seen.include?(point)

    seen << point
    max = 0
    adjacent_points(point, dry:) do |new_point|
      next if lines[new_point.y][new_point.x] == "#"

      new_dist = _longest_hike(point: new_point, dist: dist + 1, goal:, seen:, dry:)
      max = new_dist if new_dist > max
    end
    seen.delete(point)

    max
  end

  # TODO: I should be able to skip down long stretches that just go
  #       straight which should make things faster I'd think.
  def adjacent_points(point, dry:)
    x = point.x
    y = point.y

    yield points[x + 1][y] if x < lines[0].size - 1 && (dry || (lines[y][x + 1] != "<" && lines[y][x] != "<"))
    yield points[x - 1][y] if x.positive? && (dry || (lines[y][x - 1] != ">" && lines[y][x] != ">"))
    yield points[x][y + 1] if y < lines.size - 1 && (dry || (lines[y + 1][x] != "^" && lines[y][x] != "^"))
    yield points[x][y - 1] if y.positive? && (dry || (lines[y - 1][x] != "v" && lines[y][x] != "v"))
  end

  def points
    @points ||= Hash.new do |x_hash, x|
      x_hash[x] = Hash.new do |y_hash, y|
        y_hash[y] = Point.new(x, y)
      end
    end
  end
end
