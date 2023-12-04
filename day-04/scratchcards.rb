# frozen_string_literal: true

require_relative "../lib/newline_input"

class Scratchcards
  include NewlineInput
  include Enumerable

  class Card
    attr_reader :copies

    def initialize(id:, winning:, actual:)
      @id = id
      @winning = winning
      @actual = actual
      @matches = @winning.intersection(@actual)
      @copies = 1
    end

    def points
      return 0 if @matches.empty?

      2**(@matches.size - 1)
    end

    def play!(all_cards)
      (0...@matches.size).each do |delta|
        all_cards[@id + delta].copy!(@copies)
      end
    end

    def copy!(additional)
      @copies += additional
    end
  end

  def each(&)
    cards.each(&)
  end

  def [](index)
    cards[index]
  end

  def play!
    each { |card| card.play!(self) }
  end

  private

  def cards
    @cards ||= lines.map(&method(:parse_card))
  end

  def parse_card(line)
    id, winning, actual = line.match(/(\d+): (.*) \| (.*)/).captures

    id = Integer(id)
    winning = winning.split.map(&method(:Integer))
    actual = actual.split.map(&method(:Integer))

    Card.new(id:, winning:, actual:)
  end
end
