# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/point"

class LavaductLagoon
  include NewlineInput

  DIRECTION_MAP = {
    0 => "R",
    1 => "D",
    2 => "L",
    3 => "U"
  }.freeze

  def size(extract: false)
    perimeter = segments(extract:).map(&:size).sum

    # trapezoid formula
    interior = segments.map do |segment|
      a = segment.start_point
      b = segment.end_point
      (a.y + b.y) * (a.x - b.x)
    end.sum / 2

    interior + (perimeter / 2) + 1
  end

  def segments(extract: false)
    @segments ||= lines.reduce([[], Point.new(0, 0)]) do |(segments, start_point), line|
      direction, size, color = line.split
      size = size.to_i
      color = color[2...-1]

      if extract
        size = "0x#{color[0...-1]}".to_i(16)
        direction = DIRECTION_MAP.fetch(color[-1].to_i)
      end

      end_point = end_point(start_point, direction, size)

      segments << LavaductLagoon::Segment.new(
        start_point:,
        end_point:,
        size:
      )

      [segments, end_point]
    end[0]
  end

  private

  def end_point(start, direction, size)
    case direction
    when "R"
      Point.new(start.x + size, start.y)
    when "D"
      Point.new(start.x, start.y + size)
    when "L"
      Point.new(start.x - size, start.y)
    when "U"
      Point.new(start.x,  start.y - size)
    end
  end
end

class LavaductLagoon
  class Segment
    attr_reader :start_point,
                :end_point,
                :size

    def initialize(start_point:, end_point:, size:)
      @start_point = start_point
      @end_point = end_point
      @size = size
    end
  end
end
