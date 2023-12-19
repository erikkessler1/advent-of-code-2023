# frozen_string_literal: true

require_relative "../lib/newline_input"

class Aplenty
  include NewlineInput

  def parts
    workflow_runner = Aplenty::WorkflowRunner.new(workflows)

    lines.select do |line|
      line.start_with?("{")
    end.map do |line|
      values = eval(line.gsub("=", ":"))
      Aplenty::Part.new(**values, workflow_runner:)
    end
  end

  def ranged_parts
    workflow_runner = Aplenty::RangedWorkflowRunner.new(workflows)
    part = Aplenty::RangedPart.new(
      x: (1..4000),
      m: (1..4000),
      a: (1..4000),
      s: (1..4000),
      state: "in"
    )

    workflow_runner.run(part)
  end

  private

  def workflows
    lines.reject do |line|
      line.empty? || line.start_with?("{")
    end.to_h do |line|
      workflow = Aplenty::Workflow.parse(line)
      [workflow.id, workflow]
    end
  end
end

class Aplenty
  class WorkflowRunner
    def initialize(workflows)
      @workflows = workflows
    end

    def run(part)
      current = "in"
      current = workflows.fetch(current).run(part) until ["A", "R"].include?(current)

      current
    end

    private

    attr_reader :workflows
  end
end

class Aplenty
  class RangedWorkflowRunner
    def initialize(workflows)
      @workflows = workflows
    end

    def run(part)
      live_parts = [part]
      terminal_parts = []

      while live_parts.any?
        part = live_parts.pop
        workflow = workflows.fetch(part.state)
        workflow.run_ranged(part) do |new_part|
          if new_part.terminal?
            terminal_parts << new_part
          else
            live_parts << new_part
          end
        end
      end

      terminal_parts
    end

    private

    attr_reader :workflows
  end
end

class Aplenty
  class Workflow
    def self.parse(line)
      id, steps = line.match("([a-z]+){(.+)}").captures
      steps = steps.split(",")

      new(id:, steps:)
    end

    attr_reader :id

    def initialize(id:, steps:)
      @id = id
      @steps = steps
    end

    def run(part)
      steps.each do |step|
        return step unless step.include?(":")

        condition, next_workflow = step.split(":")
        return next_workflow if part.instance_eval(condition)
      end

      raise "Fatal Error!"
    end

    def run_ranged(part)
      base_part = part
      steps.each do |step|
        property, operator, next_value, next_workflow = parse_step(step)
        next yield base_part.merge(state: next_workflow) if operator.nil?

        current_value = base_part.send(property)

        if operator == "<"
          yield base_part.merge(
            state: next_workflow,
            property => (current_value.first..next_value - 1)
          )
          base_part = base_part.merge(
            property.to_sym => (next_value..current_value.last)
          )
        elsif operator == ">"
          yield base_part.merge(
            state: next_workflow,
            property.to_sym => (next_value + 1..current_value.last)
          )
          base_part = base_part.merge(
            property.to_sym => (current_value.first..next_value)
          )
        end
      end
    end

    private

    attr_reader :steps

    def parse_step(step)
      return [nil, nil, nil, step] if !step.include?(":")

      captures = step.match(/([a-z]+)(<|>)(\d+):([a-z]+|A|R)/).captures
      captures[0] = captures[0].to_sym
      captures[2] = captures[2].to_i

      captures
    end
  end
end

class Aplenty
  class Part
    attr_reader :x,
                :m,
                :a,
                :s

    def initialize(x:, m:, a:, s:, workflow_runner:)
      @x = x
      @m = m
      @a = a
      @s = s
      @workflow_runner = workflow_runner
    end

    def rating
      x + m + a + s
    end

    def accepted?
      workflow_runner.run(self) == "A"
    end

    private

    attr_reader :workflow_runner
  end
end

class Aplenty
  class RangedPart
    attr_reader :x,
                :m,
                :a,
                :s,
                :state

    def initialize(x:, m:, a:, s:, state:)
      @x = x
      @m = m
      @a = a
      @s = s
      @state = state
    end

    def merge(**)
      self.class.new(
        x:,
        m:,
        a:,
        s:,
        state:,
        **
      )
    end

    def combinations
      x.size * m.size * a.size * s.size
    end

    def terminal?
      ["A", "R"].include?(state)
    end

    def accepted?
      state == "A"
    end

    private

    attr_reader :workflow_runner
  end
end
