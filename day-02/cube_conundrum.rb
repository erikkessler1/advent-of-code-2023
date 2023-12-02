# frozen_string_literal: true

require_relative "../lib/newline_input"

class CubeConundrum
  include NewlineInput

  class Game
    attr_reader :id,
                :sets

    def initialize(id:, sets:)
      @id = id
      @sets = sets
    end

    def valid?
      sets.all? do |set|
        red, green, blue = set.values_at(:red, :green, :blue)
        red <= 12 && green <= 13 && blue <= 14
      end
    end

    def power
      [:red, :green, :blue].map do |color|
        sets.map { |set| set.fetch(color, 0) }.max
      end.reduce(&:*)
    end
  end

  def games
    lines.map(&method(:parse_game))
  end

  private

  def parse_game(line)
    id, sets = line.split(": ")

    id = Integer(id.sub("Game ", ""))
    sets = sets.split(";").map(&method(:parse_set))

    Game.new(id:, sets:)
  end

  def parse_set(set)
    set.split(", ").each_with_object(empty_color_counts) do |color_count, color_counts|
      count, color = color_count.split

      count = Integer(count)
      color = color.to_sym

      color_counts[color] = count
    end
  end

  def empty_color_counts
    { red: 0, green: 0, blue: 0 }
  end
end
