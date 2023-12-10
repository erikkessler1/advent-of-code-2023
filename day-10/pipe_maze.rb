# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/point"

class PipeMaze
  include NewlineInput
  include Enumerable

  EXPANDED_PIPES = {
    "F" => [
      ["~", "~", "~"],
      ["~", "█", "█"],
      ["~", "█", "~"]
    ],
    "|" => [
      ["~", "█", "~"],
      ["~", "█", "~"],
      ["~", "█", "~"]
    ],
    "7" => [
      ["~", "~", "~"],
      ["█", "█", "~"],
      ["~", "█", "~"]
    ],
    "J" => [
      ["~", "█", "~"],
      ["█", "█", "~"],
      ["~", "~", "~"]
    ],
    "-" => [
      ["~", "~", "~"],
      ["█", "█", "█"],
      ["~", "~", "~"]
    ],
    "L" => [
      ["~", "█", "~"],
      ["~", "█", "█"],
      ["~", "~", "~"]
    ]
  }.freeze

  attr_reader :loop,
              :start

  def initialize(...)
    super
    @start = find { |_point, value| value == "S" }[0]
    lines[start.y][start.x] = start_pipe
    @loop = find_loop
  end

  def [](point)
    lines[point.y][point.x]
  end

  # Expand the grid by 9 times to capture how we can move between
  # pipes. For example, `|` becomes:
  #
  #    ~█~
  #    ~█~
  #    ~█~
  #
  # We can move along the `~`, but they don't count as "open tiles".
  def expand!
    new_lines = []
    new_line = [[], [], []]
    on_new_line = lambda do
      new_lines.concat(new_line)
      new_line = [[], [], []]
    end

    each(on_new_line:) do |point|
      if loop.include?(point)
        expanded_pipe = EXPANDED_PIPES.fetch(self[point])
        new_line[0].concat(expanded_pipe[0])
        new_line[1].concat(expanded_pipe[1])
        new_line[2].concat(expanded_pipe[2])
      else
        new_line[0].push(".", ".", ".")
        new_line[1].push(".", ".", ".")
        new_line[2].push(".", ".", ".")
      end
    end

    @expanded = true
    @lines = new_lines
  end

  def fill!
    raise "Can't `#fill!` unless `#expand!`-ed" unless @expanded

    to_visit = [
      *(0..max_x).map { |x| Point.new(x, 0) },
      *(0..max_x).map { |x| Point.new(x, max_y) },
      *(0..max_y).map { |y| Point.new(0, y) },
      *(0..max_y).map { |y| Point.new(max_x, y) }
    ].reject { |point| loop.include?(point) }.uniq

    until to_visit.empty?
      point = to_visit.pop
      next unless open?(point) || permeable?(point)

      lines[point.y][point.x] = "X"
      point.adjacent_points(max_x:, max_y:).each do |new_point|
        next unless open?(new_point) || permeable?(new_point)

        to_visit << new_point
      end
    end
  end

  def each(on_new_line: nil)
    lines.size.times do |y|
      lines[0].size.times do |x|
        point = Point.new(x, y)
        value = self[point]
        yield point, value
      end

      on_new_line&.call
    end
  end

  def to_s
    buffer = StringIO.new

    each(on_new_line: -> { buffer.puts }) do |point, value|
      next buffer.print value if @expanded

      if loop.include?(point)
        buffer.print self[point]
      else
        buffer.print "."
      end
    end

    buffer.string
  end

  private

  # A little gross and the might be a cleaner algorithm, but we need
  # to figure out what the start pipe should be.
  def start_pipe
    above = Point.new(start.x, start.y - 1) if start.y.positive?
    right = Point.new(start.x + 1, start.y) if start.x < max_x
    below = Point.new(start.x, start.y + 1) if start.y < max_y
    left = Point.new(start.x - 1, start.y) if start.x.positive?

    case above ? self[above] : nil
    when "F", "|", "7"
      # NOOP
    else
      above = nil
    end

    case right ? self[right] : nil
    when "7", "J", "-"
      # NOOP
    else
      right = nil
    end

    case below ? self[below] : nil
    when "|", "J", "L"
      # NOOP
    else
      below = nil
    end

    case left ? self[left] : nil
    when "L", "-", "F"
      # NOOP
    else
      left = nil
    end

    if above && below
      "|"
    elsif left && right
      "-"
    elsif above && left
      "J"
    elsif above && right
      "L"
    elsif below && left
      "7"
    elsif below && right
      "F"
    end
  end

  def find_loop
    points_seen = Set.new
    to_visit = [start]

    until to_visit[0] == to_visit[1]
      new_to_visit = []
      to_visit.each do |point|
        points_seen << point
        new_to_visit.concat(connected_points(point))
      end

      to_visit = new_to_visit.reject do |point|
        points_seen.include?(point)
      end
    end

    points_seen << to_visit[0]
    points_seen << to_visit[1]
    points_seen
  end

  def connected_points(point)
    x = point.x
    y = point.y
    connected = []

    case self[point]
    when "F"
      connected << Point.new(x, y + 1) if y < max_y
      connected << Point.new(x + 1, y) if y < max_x
    when "|"
      connected << Point.new(x, y - 1) if y.positive?
      connected << Point.new(x, y + 1) if y < max_y
    when "7"
      connected << Point.new(x - 1, y) if x.positive?
      connected << Point.new(x, y + 1) if y < max_y
    when "J"
      connected << Point.new(x - 1, y) if x.positive?
      connected << Point.new(x, y - 1) if y.positive?
    when "-"
      connected << Point.new(x - 1, y) if x.positive?
      connected << Point.new(x + 1, y) if y < max_x
    when "L"
      connected << Point.new(x, y - 1) if y.positive?
      connected << Point.new(x + 1, y) if y < max_x
    end

    connected
  end

  def max_y
    lines.size - 1
  end

  def max_x
    lines[0].size - 1
  end

  def open?(point)
    lines[point.y][point.x] == "."
  end

  def permeable?(point)
    lines[point.y][point.x] == "~"
  end
end
