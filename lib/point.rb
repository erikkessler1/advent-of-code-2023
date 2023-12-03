# frozen_string_literal: true

class Point
  attr_reader :x,
              :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def adjacent_points
    deltas = (-1..1).to_a
    deltas.product(deltas).map do |(dx, dy)|
      next if dx.zero? && dy.zero?

      Point.new(dx + x, dy + y)
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
