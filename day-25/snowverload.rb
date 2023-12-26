# frozen_string_literal: true

require_relative "../lib/newline_input"

class Snowverload
  include NewlineInput

  def cut
    cuts = find_cuts
    seen = Set.new
    to_visit = [components[cuts[0][0]]]

    until to_visit.empty?
      component = to_visit.shift
      component.edges.each do |other|
        next if seen.include?(other)

        edge = [component.id, other.id].sort
        next if cuts.include?(edge)

        seen << other
        to_visit << other
      end
    end

    seen.size * (components.size - seen.size)
  end

  private

  def find_cuts
    edge_counts = build_graph

    components.each_value do |start|
      seen = Set.new
      to_visit = [start]
      until to_visit.empty?
        component = to_visit.shift
        component.edges.each do |other|
          next if seen.include?(other)

          seen << other
          edge = [component.id, other.id].sort
          edge_counts[edge] += 1
          to_visit << other
        end
      end
    end

    # Cut the most traversed edges.
    edge_counts.sort_by { |_k, v| v }[-3..].map(&:first)
  end

  def build_graph
    edge_counts = {}

    lines.each do |line|
      component, others = line.split(": ")
      component = components[component]

      others = others.split
      others.each do |other|
        other = components[other]
        edge_counts[component.connect(other)] = 0
        other.connect(component)
      end
    end

    edge_counts
  end

  def components
    @components ||= Hash.new do |hash, id|
      hash[id] = Snowverload::Component.new(id)
    end
  end
end

class Snowverload
  class Component
    attr_reader :id,
                :edges

    def initialize(id)
      @id = id
      @edges = []
    end

    def connect(other)
      edges << other
      [id, other.id].sort
    end

    def to_s
      id
    end

    def inspect
      id
    end
  end
end
