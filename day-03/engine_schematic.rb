# frozen_string_literal: true

require_relative "../lib/point"

require_relative "schematic_part"
require_relative "schematic_symbol"

class EngineSchematic
  def self.parse(lines)
    schematic = new
    schematic.parse(lines)

    schematic
  end

  attr_reader :parts

  def initialize
    @symbol_index = {}
    @parts = []
  end

  def parse(lines)
    current_part = nil
    on_new_line = lambda do
      parts << current_part if current_part
      current_part = nil
    end

    each_value(lines, on_new_line) do |point, value|
      case value
      when nil
        parts << current_part if current_part
        current_part = nil
      when Integer
        (current_part ||= SchematicPart.new).add_digit(value, at: point)
      when SchematicSymbol
        parts << current_part if current_part
        current_part = nil
        symbol_index[point] = value
      end
    end

    validate_parts!
  end

  def gears
    symbol_index.values.filter(&:gear?)
  end

  private

  attr_reader :symbol_index

  def each_value(lines, on_new_line)
    (0...lines.size).each do |y|
      (0...lines[0].size).each do |x|
        point = Point.new(x, y)
        value = parse_value(lines[point.y][point.x])

        yield point, value
      end

      on_new_line.call
    end
  end

  def validate_parts!
    @parts = parts.filter do |part|
      valid = false

      part.coordinates.each do |point|
        point.adjacent_points.each do |adjacent_point|
          symbol = symbol_index[adjacent_point]
          next if symbol.nil?

          valid = true
          symbol.add_part(part)
        end
      end

      valid
    end
  end

  def parse_value(value)
    return nil if value == "."

    Integer(value)
  rescue ArgumentError
    SchematicSymbol.new(value)
  end
end
