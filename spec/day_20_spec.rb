# frozen_string_literal: true

require_relative "../day-20/pulse_propagation"

describe PulsePropagation, day: 20 do
  subject(:pulse_propagation) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        broadcaster -> a, b, c
        %a -> b
        %b -> c
        %c -> inv
        &inv -> a
      INPUT
    end

    it "finds pulse counts", part: 1 do
      expect(pulse_propagation.pulse_product(presses: 1_000)).to eq(32_000_000)
    end
  end

  context "with more interesting sample input", sample: true do
    let(:input) do
      <<~INPUT
        broadcaster -> a
        %a -> inv, con
        &inv -> b
        %b -> con
        &con -> output
      INPUT
    end

    it "finds pulse counts", part: 1 do
      expect(pulse_propagation.pulse_product(presses: 1_000)).to eq(11_687_500)
    end
  end

  it "finds pulse counts", part: 1 do
    expect(pulse_propagation.pulse_product(presses: 1_000)).to eq(763_500_168)
  end

  it "finds presses until rx is low", part: 2 do
    presses = 0
    low_ats = {}
    on_low = lambda do |mod|
      low_ats[mod.id] = presses
    end

    # These need to go low at the same time for `rx` to go low.
    pulse_propagation.alert_on_low!("tr", &on_low)
    pulse_propagation.alert_on_low!("xm", &on_low)
    pulse_propagation.alert_on_low!("dr", &on_low)
    pulse_propagation.alert_on_low!("nh", &on_low)

    loop do
      presses += 1
      pulse_propagation.press
      break if low_ats.size == 4
    end

    expect(low_ats.values.least_common_multiple).to eq(207_652_583_562_007)
  end
end
