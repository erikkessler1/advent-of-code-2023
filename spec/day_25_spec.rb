# frozen_string_literal: true

require_relative "../day-25/snowverload"

describe Snowverload, day: 25 do
  subject(:snowverload) { described_class.new(input) }

  it "finds the cut", part: 1 do
    expect(snowverload.cut).to eq(507_626)
  end
end
