# frozen_string_literal: true

require_relative "almanac_parser"

class Almanac
  def initialize(seeds:, maps:)
    @seeds = seeds
    @maps = maps
  end

  def seeds
    @seeds.map do |id|
      range = AlmanacRange.new(id, id)
      AlmanacSeedRange.new(range, maps: @maps)
    end
  end

  def seed_ranges
    @seeds.each_slice(2).map do |(start, count)|
      range = AlmanacRange.new(start, start + (count - 1))
      AlmanacSeedRange.new(range, maps: @maps)
    end
  end
end

class AlmanacSeedRange
  def initialize(range, maps:)
    @range = range
    @maps = maps
  end

  def min_location
    location_ranges.map(&:min).min
  end

  def location_ranges
    current_type = "seed"
    current_ranges = [@range]

    until current_type == "location"
      map = @maps[current_type]
      map.entries.each do |entry|
        current_ranges = current_ranges.flat_map do |range|
          range.applied? ? [range] : entry.apply(range)
        end
      end
      current_ranges.each(&:reset)
      current_type = map.destination_type
    end

    current_ranges
  end
end

class AlmanacMap
  attr_reader :source_type,
              :destination_type,
              :entries

  def initialize(source_type:, destination_type:, entries:)
    @source_type = source_type
    @destination_type = destination_type
    @entries = entries
  end
end

class AlmanacRange
  attr_accessor :min,
                :max,
                :offset

  def initialize(min, max, offset: 0)
    @min = min
    @max = max
    @offset = offset
    @applied = false
  end

  # This is disgusting.
  def apply(other)
    ranges = []

    # We should leave this block with an "open" range (i.e., `max` not
    # set yet). The next `if-block` should close it.
    if other.min < min
      ranges << AlmanacRange.new(other.min, nil)
      if other.max >= min
        ranges.last.max = min
        ranges << AlmanacRange.new(min + offset, nil).tap(&:applied!)
      end
    elsif other.min <= max
      ranges << AlmanacRange.new(other.min + offset, nil).tap(&:applied!)
    else
      ranges << AlmanacRange.new(other.min, nil)
    end

    if other.max > max
      if other.min <= max
        ranges.last.max = (max + offset)
        ranges << AlmanacRange.new(max, nil)
      end
      ranges.last.max = other.max
    elsif other.max >= min
      ranges.last.max = (other.max + offset)
    else
      ranges.last.max = other.max
    end

    ranges
  end

  # We use `@applied` to track if we've "applied" a mapping since we
  # don't want to re-apply ranges.
  def applied?
    @applied
  end

  def applied!
    @applied = true
  end

  def reset
    @applied = false
  end
end
