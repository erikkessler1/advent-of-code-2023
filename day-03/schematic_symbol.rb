# frozen_string_literal: true

class SchematicSymbol
  attr_reader :value

  def initialize(value)
    @value = value
    @parts = Set.new
  end

  def gear?
    value == "*" && @parts.size == 2
  end

  def gear_ratio
    raise "Not a gear!" if !gear?

    @parts.map(&:number).reduce(&:*)
  end

  def add_part(part)
    @parts << part
  end

  def to_s
    @value
  end
end
