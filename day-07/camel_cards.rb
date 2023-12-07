# frozen_string_literal: true

require_relative "../lib/newline_input"

class CamelCards
  include NewlineInput

  def self.joker_mode?
    false
  end

  def hands
    lines.map do |line|
      cards, bid = line.split
      CamelCards::Hand.new(
        cards:,
        bid: Integer(bid)
      )
    end
  end

  def total_winnings
    hands.sort.each_with_index.map do |hand, i|
      hand.bid * (i + 1)
    end.sum
  end
end

class CamelCards
  class Hand
    VALUE_MAP = {
      "T" => 10,
      "J" => 11,
      "Q" => 12,
      "K" => 13,
      "A" => 14
    }.freeze

    attr_reader :bid

    def initialize(cards:, bid:)
      @cards = cards
      @bid = bid
    end

    def value
      return @value if defined?(@value)

      card_values = @cards.each_char.map do |card|
        next 1 if card == "J" && CamelCards.joker_mode?

        VALUE_MAP.fetch(card) { Integer(card) }
      end

      @value = [type] + card_values
    end

    def type
      tally = @cards.each_char.tally
      if CamelCards.joker_mode? && tally.key?("J")
        j_count = tally.delete("J")
        max, = tally.max_by { |(_, v)| v }
        return 6 if j_count == 5

        tally[max] = tally[max] + j_count
      end
      counts = tally.values.sort.reverse

      case counts
      in [5]
        6
      in [4, 1]
        5
      in [3, 2]
        4
      in [3, 1, 1]
        3
      in [2, 2, 1]
        2
      in [2, 1, 1, 1]
        1
      else
        0
      end
    end

    def <=>(other)
      value <=> other.value
    end

    def to_s
      "#{@cards} #{bid} T: #{type}"
    end
  end
end
