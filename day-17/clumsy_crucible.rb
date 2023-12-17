# frozen_string_literal: true

require_relative "../lib/newline_input"
require_relative "../lib/point"

class ClumsyCrucible
  include NewlineInput

  def min_heat_loss
    ClumsyCrucible::HeatLossSearcher.search(self)
  end

  def min_x
    0
  end

  def min_y
    0
  end

  def max_x
    lines[0].size - 1
  end

  def max_y
    lines.size - 1
  end

  def can_stop?(_block)
    true
  end

  def adjacent_blocks(block)
    x = block.x
    y = block.y
    streak = block.streak

    case block.direction
    when ">"
      yield Block.new(x, y - 1, direction: "^", streak: 1) if y > min_y
      yield Block.new(x, y + 1, direction: "V", streak: 1) if y < max_y
      yield Block.new(x + 1, y, direction: ">", streak: streak + 1) if x < max_x && streak < 3
    when "<"
      yield Block.new(x, y - 1, direction: "^", streak: 1) if y > min_y
      yield Block.new(x, y + 1, direction: "V", streak: 1) if y < max_y
      yield Block.new(x - 1, y, direction: "<", streak: streak + 1) if x > min_x && streak < 3
    when "^"
      yield Block.new(x - 1, y, direction: "<", streak: 1) if x > min_x
      yield Block.new(x + 1, y, direction: ">", streak: 1) if x < max_x
      yield Block.new(x, y - 1, direction: "^", streak: streak + 1) if y > min_y && streak < 3
    when "V"
      yield Block.new(x - 1, y, direction: "<", streak: 1) if x > min_x
      yield Block.new(x + 1, y, direction: ">", streak: 1) if x < max_x
      yield Block.new(x, y + 1, direction: "V", streak: streak + 1) if y < max_y && streak < 3
    end
  end

  def loss_at(block)
    losses[block.y][block.x]
  end

  private

  def losses
    @losses ||= lines.map do |line|
      line.each_char.map(&:to_i)
    end
  end
end

class UltraCrucible < ClumsyCrucible
  def adjacent_blocks(block)
    x = block.x
    y = block.y
    streak = block.streak

    case block.direction
    when ">"
      yield Block.new(x, y - 1, direction: "^", streak: 1) if y > min_y && streak >= 4
      yield Block.new(x, y + 1, direction: "V", streak: 1) if y < max_y && streak >= 4
      yield Block.new(x + 1, y, direction: ">", streak: streak + 1) if x < max_x && streak < 10
    when "<"
      yield Block.new(x, y - 1, direction: "^", streak: 1) if y > min_y && streak >= 4
      yield Block.new(x, y + 1, direction: "V", streak: 1) if y < max_y && streak >= 4
      yield Block.new(x - 1, y, direction: "<", streak: streak + 1) if x > min_x && streak < 10
    when "^"
      yield Block.new(x - 1, y, direction: "<", streak: 1) if x > min_x && streak >= 4
      yield Block.new(x + 1, y, direction: ">", streak: 1) if x < max_x && streak >= 4
      yield Block.new(x, y - 1, direction: "^", streak: streak + 1) if y > min_y && streak < 10
    when "V"
      yield Block.new(x - 1, y, direction: "<", streak: 1) if x > min_x && streak >= 4
      yield Block.new(x + 1, y, direction: ">", streak: 1) if x < max_x && streak >= 4
      yield Block.new(x, y + 1, direction: "V", streak: streak + 1) if y < max_y && streak < 10
    end
  end

  def can_stop?(block)
    block.streak >= 4
  end
end

class ClumsyCrucible
  class HeatLossSearcher
    def self.search(crucible)
      new(crucible).search
    end

    attr_reader :crucible

    def initialize(crucible)
      @crucible = crucible
    end

    def search
      paths = []

      while to_visit.any?
        block = to_visit.shift
        current_loss = loss_by_block[block]
        next paths << current_loss if machine_parts_factory?(block) && crucible.can_stop?(block)

        crucible.adjacent_blocks(block) do |new_block|
          new_loss = current_loss + crucible.loss_at(new_block)
          next if new_loss >= (loss_by_block[new_block] || Float::INFINITY)

          loss_by_block[new_block] = new_loss
          to_visit << new_block
        end
      end

      paths.min
    end

    private

    def to_visit
      @to_visit ||= lava_pools
    end

    def loss_by_block
      @loss_by_block ||= lava_pools.zip([0, 0]).to_h
    end

    def lava_pools
      [
        ClumsyCrucible::Block.new(0, 0, direction: ">", streak: 0),
        ClumsyCrucible::Block.new(0, 0, direction: "V", streak: 0)
      ]
    end

    def machine_parts_factory?(block)
      block.x == crucible.max_x &&
        block.y == crucible.max_y
    end
  end
end

class ClumsyCrucible
  class Block
    attr_reader :x,
                :y,
                :direction,
                :streak

    def initialize(x, y, direction:, streak:)
      @x = x
      @y = y
      @direction = direction
      @streak = streak
    end

    def eql?(other)
      self.class == other.class &&
        x == other.x &&
        y == other.y &&
        direction == other.direction &&
        streak == other.streak
    end

    alias_method :==, :eql?

    def hash
      [self.class, x, y, direction, streak].hash
    end

    def to_s
      "(#{x},#{y}, #{direction}, #{streak})"
    end
  end
end
