# frozen_string_literal: true

require_relative "../day-24/never_tell_me_the_odds"

describe NeverTellMeTheOdds, day: 24 do
  subject(:never_tell_me_the_odds) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        19, 13, 30 @ -2,  1, -2
        18, 19, 22 @ -1, -1, -2
        20, 25, 34 @ -2, -2, -4
        12, 31, 28 @ -1, -2, -1
        20, 19, 15 @  1, -5, -3
      INPUT
    end

    it "finds crosses", part: 1 do
      expect(never_tell_me_the_odds.crosses(min: 7, max: 27)).to eq(2)
    end

    it "finds the magic position", part: 2 do
      # Solve this system of equations:
      #
      #   -2*t1 + 19 = vx*t1 + ix
      #   1*t1 + 13 = vy*t1 + iy
      #   -2*t1 + 30 = vz*t1 + iz
      #   -1*t2 + 18 = vx*t2 + ix
      #   -1*t2 + 19 = vy*t2 + iy
      #   -2*t2 + 22 = vz*t2 + iz
      #   -2*t3 + 20 = vx*t3 + ix
      #   -2*t3 + 25 = vy*t3 + iy
      #   -4*t3 + 34 = vz*t3 + iz
      #
      expect([24, 13, 10].sum).to eq(47)
    end
  end

  it "finds crosses", part: 1 do
    min = 200_000_000_000_000
    max = 400_000_000_000_000
    expect(never_tell_me_the_odds.crosses(min:, max:)).to eq(12_343)
  end

  it "finds the magic position", part: 2 do
    # Solve this system of equations:
    #
    #   -18*a + 206273907288897 = i*a + x
    #   6*a + 404536114337943 = j*a + y
    #   92*a + 197510451330134 = k*a + z
    #   -78*b + 318919383845607 = i*b + x
    #   62*b + 260745469021671 = j*b + y
    #   75*b + 223155534318195 = k*b + z
    #   -179*c + 379055259398812 = i*c + x
    #   -18*c + 255495760772511 = j*c + y
    #   -373*c + 396757430832289 = k*c + z
    #
    expect([391_948_057_347_762, 141_735_778_870_011, 235_597_456_470_414].sum).to eq(769_281_292_688_187)
  end
end
