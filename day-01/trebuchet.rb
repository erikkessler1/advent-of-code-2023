# frozen_string_literal: true

require_relative "../lib/newline_input"

class Trebuchet
  include NewlineInput

  class IntParser
    def parse(line)
      line.each_char.map do |char|
        Integer(char)
      rescue ArgumentError
        nil
      end.compact
    end
  end

  class DigitParser
    DIGITS = {
      "one" => 1,
      "two" => 2,
      "three" => 3,
      "four" => 4,
      "five" => 5,
      "six" => 6,
      "seven" => 7,
      "eight" => 8,
      "nine" => 9
    }.tap do |digits|
      ints = digits.values
      int_map = ints.map(&:to_s).zip(ints).to_h

      digits.merge!(int_map)
    end

    def parse(line)
      result = []

      until line.empty?
        DIGITS.each do |digit, value|
          next unless line.start_with?(digit)

          result << value
          break
        end

        line = line[1..]
      end

      result
    end
  end

  def initialize(input, parser:)
    super(input)
    @parser = parser
  end

  def calibration_values
    lines.map(&method(:calibration_value))
  end

  private

  attr_reader :parser

  def calibration_value(line)
    ints = parser.parse(line)

    (ints[0] * 10) + ints[-1]
  end
end
