# frozen_string_literal: true

require_relative "../day-07/camel_cards"

describe CamelCards, day: 7 do
  subject(:camel_cards) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        32T3K 765
        T55J5 684
        KK677 28
        KTJJT 220
        QQQJA 483
      INPUT
    end

    it "finds the total winnings", part: 1 do
      expect(camel_cards.total_winnings).to eq(6_440)
    end

    context "when in joker mode" do
      before { allow(described_class).to receive(:joker_mode?).and_return(true) }

      it "finds the total winnings", part: 2 do
        expect(camel_cards.total_winnings).to eq(5_905)
      end
    end
  end

  it "finds the total winnings", part: 1 do
    expect(camel_cards.total_winnings).to eq(249_638_405)
  end

  context "when in joker mode" do
    before { allow(described_class).to receive(:joker_mode?).and_return(true) }

    it "finds the total winnings", part: 2 do
      expect(camel_cards.total_winnings).to eq(249_776_650)
    end
  end
end
