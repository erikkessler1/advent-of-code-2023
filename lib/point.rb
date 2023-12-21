# frozen_string_literal: true

class Point
  attr_reader :x,
              :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def adjacent_points(min_x: 0, min_y: 0, max_x: nil, max_y: nil, include_diagonal: true)
    deltas = (-1..1).to_a
    deltas.product(deltas).map do |(dx, dy)|
      next if dx.zero? && dy.zero?
      next unless include_diagonal || (dx.zero? || dy.zero?)

      new_x = dx + x
      next if min_x && new_x < min_x
      next if max_x && new_x > max_x

      new_y = dy + y
      next if min_y && new_y < min_y
      next if max_y && new_y > max_y

      Point.new(new_x, new_y)
    end.compact
  end

  def eql?(other)
    self.class == other.class &&
      x == other.x &&
      y == other.y
  end

  alias_method :==, :eql?

  def hash
    [self.class, x, y].hash
  end

  def to_s
    "(#{x},#{y})"
  end
end
