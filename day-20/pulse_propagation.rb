# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/extensions"

class PulsePropagation
  include NewlineInput

  def pulse_product(presses:)
    presses.times do
      press
    end

    pulse_counts.values.reduce(&:*)
  end

  def press
    pulses_to_propagate = [[nil, configuration.broadcaster, :low]]

    until pulses_to_propagate.empty?
      source, target, signal = pulses_to_propagate.shift
      pulse_counts[signal] += 1

      target.pulse(source, signal).each do |next_pulse|
        pulses_to_propagate << next_pulse
      end
    end
  end

  def alert_on_low!(id, &block)
    configuration.modules.fetch(id).alert_on_low!(block)
  end

  def configuration
    @configuration ||= ModuleConfiguration.new(lines)
  end

  def pulse_counts
    @pulse_counts ||= { low: 0, high: 0 }
  end
end

class PulsePropagation
  class ModuleConfiguration
    attr_reader :modules

    def initialize(lines)
      @modules = Hash.new { |hash, key| hash[key] = OutputModule.new(key) }
      lines.each(&method(:parse_module))
      lines.each(&method(:parse_output))
    end

    def broadcaster
      modules.fetch("broadcaster")
    end

    private

    def parse_module(line)
      input, = line.split(" -> ")
      kind, id = input.match(/(&|%)?(.*)/).captures

      type = FlipFlopModule if kind == "%"
      type = ConjunctionModule if kind == "&"
      type = BroadcastModule if id == "broadcaster"

      modules[id] = type.new(id)
    end

    def parse_output(line)
      input, outputs = line.split(" -> ")
      _, id = input.match(/(&|%)?(.*)/).captures

      outputs = outputs.split(", ")
      source = modules.fetch(id)

      outputs.each do |output|
        destination = modules[output]
        source.connect!(destination)
        destination.on_connected(source)
      end
    end
  end
end

class PulsePropagation
  class Module
    attr_reader :id,
                :connections

    def initialize(id)
      @id = id
      @connections = []
      @alert_on_low = nil
    end

    def alert_on_low!(block)
      @alert_on_low = block
    end

    def connect!(destination)
      connections << destination
    end

    def on_connected(_source)
      # A hook
    end

    def pulse(_source, signal)
      if signal == :low && @alert_on_low
        @alert_on_low.call(self)
        @alert_on_low = nil
      end

      []
    end

    def inspect
      "#<#{self.class.name} #{id}>"
    end

    def to_s
      id
    end
  end
end

class PulsePropagation
  class BroadcastModule < Module
    def pulse(_source, signal)
      super + connections.map do |connection|
        [self, connection, signal]
      end
    end
  end
end

class PulsePropagation
  class OutputModule < Module
  end
end

class PulsePropagation
  class FlipFlopModule < Module
    attr_reader :state

    def initialize(...)
      super(...)
      @state = :off
    end

    def pulse(_source, signal)
      return super if signal == :high

      next_signal = state == :on ? :low : :high
      @state = state == :on ? :off : :on

      super + connections.map do |connection|
        [self, connection, next_signal]
      end
    end

    def to_s
      "%#{id}"
    end
  end
end

class PulsePropagation
  class ConjunctionModule < Module
    attr_reader :inputs

    def initialize(...)
      super(...)
      @inputs = {}
    end

    def on_connected(source)
      inputs[source] = :low
    end

    def pulse(source, signal)
      inputs[source] = signal

      next_signal = inputs.values.all? { _1 == :high } ? :low : :high
      super + connections.map do |connection|
        [self, connection, next_signal]
      end
    end

    def to_s
      "&#{id}"
    end
  end
end
