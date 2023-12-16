# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/extensions"

class Cave
  include NewlineInput
  include Enumerable

  def each
    lines.size.times do |y|
      yield Cave::Beam.new(x: 0, y:, direction: ">")
      yield Cave::Beam.new(x: lines[0].size - 1, y:, direction: "<")
    end

    lines[0].size.times do |x|
      yield Cave::Beam.new(x:, y: 0, direction: "V")
      yield Cave::Beam.new(x:, y: lines.size - 1, direction: "^")
    end
  end

  def beam!(start = Cave::Beam.new)
    beams = [start]
    tiles ||= Array.new(lines.size) { Array.new(lines[0].size) }

    until beams.empty?
      beams.pop.visit!(tiles)&.next_beams(lines) do |next_beam|
        beams << next_beam
      end
    end

    tiles.flatten.count(&:non_nil?)
  end
end

class Cave
  class Beam
    attr_reader :x,
                :y,
                :direction

    def initialize(x: 0, y: 0, direction: ">")
      @x = x
      @y = y
      @direction = direction
    end

    def visit!(tiles)
      return if tiles[y][x] == direction

      tiles[y][x] = direction
      self
    end

    def next_beams(lines, &)
      case [lines[y][x], direction]
      # CONTINUE
      in [".", _] | ["-", "<"] | ["-", ">"] | ["|", "^"] | ["|", "V"]
        move(direction, lines).map(&)
      # DOWN
      in ["\\", ">"] | ["/", "<"]
        move("V", lines).map(&)
      # UP
      in ["\\", "<"] | ["/", ">"]
        move("^", lines).map(&)
      # LEFT
      in ["\\", "^"] | ["/", "V"]
        move("<", lines).map(&)
      # RIGHT
      in ["\\", "V"] | ["/", "^"]
        move(">", lines).map(&)
      # VERTICAL SPLIT
      in ["|", ">"] | ["|", "<"]
        other = dup
        move("^", lines).map(&)
        other.move("V", lines).map(&)
      # HORIZONTAL SPLIT
      in ["-", "^"] | ["-", "V"]
        other = dup
        move("<", lines).map(&)
        other.move(">", lines).map(&)
      end
    end

    def to_s
      "(#{x}, #{y}, #{direction})"
    end

    def move(move_direction, lines)
      @direction = move_direction

      case move_direction
      when ">"
        @x += 1
      when "<"
        @x -= 1
      when "^"
        @y -= 1
      when "V"
        @y += 1
      end

      return if y >= lines.size || y.negative?
      return if x >= lines[0].size || x.negative?

      self
    end
  end
end
