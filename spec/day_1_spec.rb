# frozen_string_literal: true

require_relative "../day-01/trebuchet"

describe Trebuchet, day: 1 do
  subject(:trebuchet) { described_class.new(input, parser:) }

  context "with ints", part: 1 do
    let(:parser) { described_class::IntParser.new }

    context "with sample input", :sample do
      let(:input) do
        <<~INPUT
          1abc2
          pqr3stu8vwx
          a1b2c3d4e5f
          treb7uchet
        INPUT
      end

      it "has a calibration value" do
        expect(trebuchet.calibration_values.sum).to eq(142)
      end
    end

    it "has a calibration value" do
      expect(trebuchet.calibration_values.sum).to eq(54_331)
    end
  end

  context "with digits", part: 2 do
    let(:parser) { described_class::DigitParser.new }

    context "with sample input", :sample do
      let(:input) do
        <<~INPUT
          two1nine
          eightwothree
          abcone2threexyz
          xtwone3four
          4nineeightseven2
          zoneight234
          7pqrstsixteen
        INPUT
      end

      it "has a calibration value" do
        expect(trebuchet.calibration_values.sum).to eq(281)
      end
    end

    context "with confusing input", :sample do
      let(:input) do
        <<~INPUT
          oneight
        INPUT
      end

      it "has a calibration value" do
        expect(trebuchet.calibration_values.sum).to eq(18)
      end
    end

    it "has a calibration value" do
      expect(trebuchet.calibration_values.sum).to eq(54_518)
    end
  end
end
