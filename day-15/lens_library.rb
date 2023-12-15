# frozen_string_literal: true

require_relative "../lib/newline_input"

class LensLibrary
  include NewlineInput

  Lens = Data.define(:label, :focal_length) do
    def to_int
      label.each_char.reduce(0, &HASH)
    end

    def eql?(other)
      self.class == other.class &&
        label == other.label
    end

    alias_method :==, :eql?
  end

  HASH = lambda do |current_value, char|
    current_value += char.ord
    current_value *= 17
    current_value % 256
  end

  def steps
    lines[0].split(",").map(&LensLibrary::Step.method(:new))
  end

  def focusing_power
    steps.each do |step|
      lens = step.to_lens
      box = lens_boxes[lens]
      next box.delete(lens) if step.remove?

      index = box.index(lens)
      next box << lens if index.nil?

      box[index] = lens
    end

    lens_boxes.each_with_index.flat_map do |box, box_number|
      box_number += 1

      box.each_with_index.map do |lens, slot|
        slot += 1

        box_number * slot * lens.focal_length
      end
    end.sum
  end

  private

  def lens_boxes
    @lens_boxes ||= Array.new(256) { [] }
  end
end

class LensLibrary
  class Step
    def initialize(value)
      @value = value
    end

    def to_lens
      LensLibrary::Lens.new(
        label: @value.match(/[a-z]+/).to_s,
        focal_length: begin
          Integer(@value[-1])
        rescue ArgumentError
          nil
        end
      )
    end

    def remove?
      @value[-1] == "-"
    end

    def to_int
      @value.each_char.reduce(0, &LensLibrary::HASH)
    end
  end
end
