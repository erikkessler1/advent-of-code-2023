# frozen_string_literal: true

class SchematicPart
  attr_reader :number,
              :coordinates

  def initialize
    @number = 0
    @coordinates = []
  end

  def add_digit(digit, at:)
    coordinates << at
    @number = (@number * 10) + digit
  end

  def eql?(other)
    self.class == other.class && number == other.number
  end

  alias_method :==, :eql?

  def hash
    [self.class, number].hash
  end
end
