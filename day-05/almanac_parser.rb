# frozen_string_literal: true

require_relative "../lib/newline_input"

class AlmanacParser
  include NewlineInput

  def self.parse(input)
    new(input).parse
  end

  def parse
    line_enum = [*lines, ""].to_enum
    seeds = nil
    maps = {}

    loop do
      line = line_enum.next
      next if line.empty?

      if line.start_with?("seeds:")
        seeds = parse_seeds(line)
      elsif line.include?("map:")
        map_lines = []
        map_lines << line_enum.next until line_enum.peek.empty?

        map = parse_map(line, map_lines)
        maps[map.source_type] = map
      end
    end

    Almanac.new(seeds:, maps:)
  end

  private

  def parse_seeds(line)
    _, *seeds = line.split
    seeds.map(&method(:Integer))
  end

  def parse_map(header, lines)
    source_type, destination_type = header.match(/(.*)-to-(.*) map/).captures
    entries = lines.map do |line|
      destination, source, count = line.split.map(&method(:Integer))
      AlmanacRange.new(source, source + count - 1, offset: destination - source)
    end

    AlmanacMap.new(source_type:, destination_type:, entries:)
  end
end
