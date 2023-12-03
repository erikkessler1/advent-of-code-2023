# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "engine_schematic"

class GearRatios
  include NewlineInput

  def initialize(...)
    super(...)
    @engine = EngineSchematic.parse(lines)
  end

  def parts
    @engine.parts
  end

  def gears
    @engine.gears
  end
end
