# frozen_string_literal: true

require_relative "../day-15/lens_library"

describe LensLibrary, day: 15 do
  subject(:lens_library) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
      INPUT
    end

    it "hashes steps", part: 1 do
      expect(lens_library.steps.map(&:to_int).sum).to eq(1_320)
    end

    it "finds focusing power", part: 2 do
      expect(lens_library.focusing_power).to eq(145)
    end
  end

  it "hashes steps", part: 1 do
    expect(lens_library.steps.map(&:to_int).sum).to eq(513_172)
  end

  it "finds focusing power", part: 2 do
    expect(lens_library.focusing_power).to eq(237_806)
  end
end
