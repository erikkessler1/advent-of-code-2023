# frozen_string_literal: true

require_relative "../lib/newline_input"

# Number galaxies
# Store galaxy location
# Store empty row and column indexes
# Generate pairs of galaxies
class CosmicExpansion
  include NewlineInput

  def initialize(...)
    super
    explore_universe
  end

  def galaxy_pairs
    @galaxy_pairs ||= galaxies
                      .product(galaxies)
                      .reject! { |galaxy_a, galaxy_b| galaxy_a == galaxy_b }
                      .map! { |galaxy_a, galaxy_b| CosmicExpansion::GalaxyPair.new(galaxy_a, galaxy_b, universe:) }
                      .uniq!
  end

  def expand!(...)
    universe.expand!(...)
  end

  private

  def explore_universe
    lines.each_with_index do |row, y|
      universe.register_row(y)
      row.each_char.with_index do |cell, x|
        universe.register_column(x)
        next if cell == "."

        universe.not_empty!(x, y)
        galaxies << CosmicExpansion::Galaxy.new(id: galaxies.count + 1, x:, y:)
      end
    end
  end

  def galaxies
    @galaxies ||= []
  end

  def universe
    @universe ||= CosmicExpansion::Universe.new
  end
end

class CosmicExpansion
  class Universe
    attr_reader :expansion_factor

    def initialize
      @expansion_factor = 0
    end

    def register_row(y)
      return if rows.key?(y)

      rows[y] = true
    end

    def register_column(x)
      return if columns.key?(x)

      columns[x] = true
    end

    def not_empty!(x, y)
      columns[x] = false
      rows[y] = false
    end

    def empty_rows
      @empty_rows ||= rows.select { |_, is_empty| is_empty }.keys.to_set
    end

    def empty_columns
      @empty_columns ||= columns.select { |_, is_empty| is_empty }.keys.to_set
    end

    def expand!(times = 2)
      @expansion_factor = times - 1
    end

    private

    def rows
      @rows ||= {}
    end

    def columns
      @columns ||= {}
    end
  end
end

class CosmicExpansion
  class Galaxy
    attr_reader :id,
                :x,
                :y

    def initialize(id:, x:, y:)
      @id = id
      @x = x
      @y = y
    end
  end
end

class CosmicExpansion
  class GalaxyPair
    attr_reader :galaxy_a,
                :galaxy_b,
                :universe

    def initialize(galaxy_a, galaxy_b, universe:)
      @galaxy_a = galaxy_a
      @galaxy_b = galaxy_b
      @universe = universe
    end

    def shortest_path
      x1, x2 = [galaxy_a.x, galaxy_b.x].sort
      y1, y2 = [galaxy_a.y, galaxy_b.y].sort

      extra_x = universe.empty_columns.count { |x| x < x2 && x > x1 }
      extra_y = universe.empty_rows.count { |y| y < y2 && y > y1 }

      dx = ((x2 - x1) + (extra_x * universe.expansion_factor))
      dy = ((y2 - y1) + (extra_y * universe.expansion_factor))

      dx + dy
    end

    def to_s
      "Between galaxy #{galaxy_a.id} and galaxy #{galaxy_b.id}: #{shortest_path}"
    end

    def eql?(other)
      self.class == other.class &&
        ((galaxy_a == other.galaxy_a) || (galaxy_a == other.galaxy_b)) &&
        ((galaxy_b == other.galaxy_a) || (galaxy_b == other.galaxy_b))
    end

    alias_method :==, :eql?

    def hash
      [self.class, *[galaxy_a.id, galaxy_b.id].sort].hash
    end
  end
end
