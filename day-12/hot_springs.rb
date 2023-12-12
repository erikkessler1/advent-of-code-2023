# frozen_string_literal: true

require_relative "../lib/newline_input"

class HotSprings
  include NewlineInput
  include Enumerable

  def each(...)
    spring_lists.each(...)
  end

  def unfold!(...)
    each { |list| list.unfold!(...) }
  end

  private

  def spring_lists
    @spring_lists ||= lines.map(&HotSprings::SpringList.method(:parse))
  end
end

class HotSprings
  class SpringList
    def self.parse(row)
      springs, counts = row.split
      counts = counts.split(",").map(&:to_i)
      new(springs:, counts:)
    end

    def initialize(springs:, counts:)
      @springs = springs
      @counts = counts
    end

    def possible_arrangements
      @cache = {}
      explore_arragmement
    end

    def unfold!(times)
      @springs = ([springs] * times).join("?")
      @counts = counts * times
    end

    def to_s
      "#{springs} #{counts}"
    end

    private

    attr_reader :springs,
                :counts

    def explore_arragmement(spring_i: 0, streak: 0, counts_i: 0, override: nil)
      cache_key = [spring_i, streak, counts_i, override]
      return @cache[cache_key] if @cache.key?(cache_key)
      return 0 if counts_i > counts.size

      current_spring = override || springs[spring_i]
      current_count = counts[counts_i]

      if current_spring.nil?
        if streak.positive?
          return 0 if streak != current_count

          counts_i += 1
        end

        counts_i == counts.size ? 1 : 0
      elsif current_spring == "."
        if streak.positive?
          if streak == current_count
            explore_arragmement(
              spring_i: spring_i + 1,
              streak: 0,
              counts_i: counts_i + 1
            )
          else
            0
          end
        else
          explore_arragmement(
            spring_i: spring_i + 1,
            streak: 0,
            counts_i:
          )
        end
      elsif current_spring == "#"
        explore_arragmement(
          spring_i: spring_i + 1,
          streak: streak + 1,
          counts_i:
        )
      elsif current_spring == "?"
        operational = explore_arragmement(spring_i:, streak:, counts_i:, override: ".")
        damaged = explore_arragmement(spring_i:, streak:, counts_i:, override: "#")
        operational + damaged
      end.tap do |result|
        @cache[cache_key] = result
      end
    end
  end
end
