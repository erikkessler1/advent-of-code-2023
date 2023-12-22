# frozen_string_literal: true

require_relative "../lib/newline_input"

class SandSlabs
  include NewlineInput

  def bricks
    blocks = lines.map(&Brick.method(:new))
    sorted_blocks = blocks.sort_by(&:min_z)
    set_blocks = [Brick.base]

    sorted_blocks.each do |block|
      new_z = nil
      set_blocks.each do |other_block|
        test_new_z = other_block.match(block)
        next if test_new_z.nil?
        break unless new_z.nil? || test_new_z == new_z

        new_z = test_new_z
        block.below << other_block
        other_block.above << block
      end

      block.adjust!(new_z) if new_z
      set_blocks.unshift(block)
      set_blocks.sort_by!(&:max_z).reverse!
    end

    sorted_blocks.each(&:check!)
    sorted_blocks
  end
end

class SandSlabs
  class Brick
    attr_reader :points,
                :below,
                :above

    def self.base
      new("0,0,0~9,9,0")
    end

    def initialize(line)
      a, b = line.split("~")
      ax, ay, az = a.split(",")
      bx, by, bz = b.split(",")

      xs = [ax.to_i, bx.to_i]
      ys = [ay.to_i, by.to_i]
      zs = [az.to_i, bz.to_i]

      @points = []

      (xs.min..xs.max).each do |x|
        (ys.min..ys.max).each do |y|
          (zs.min..zs.max).each do |z|
            @points << [x.to_i, y.to_i, z.to_i]
          end
        end
      end

      @below = []
      @above = []
      @can_disintergrate = true
    end

    def min_z
      points[0][2]
    end

    def max_z
      points[-1][2]
    end

    def adjust!(new_z)
      dz = points[0][2] - new_z
      points.each do |point|
        point[2] -= dz
      end
    end

    def check!
      @below[0].load_bearing! if below.size == 1
    end

    def holding
      to_check = above
      to_delete = [self]
      until to_check.empty?
        block = to_check.pop
        new_below = block.below.reject { |b| to_delete.include?(b) }
        next if new_below.size.positive?

        block.above.each { |above_block| to_check << above_block }
        to_delete << block
      end

      to_delete.size - 1
    end

    def load_bearing!
      @can_disintergrate = false
    end

    def can_disintergrate?
      @can_disintergrate
    end

    def match(other)
      other.points.each do |other_point|
        points.each do |point|
          return max_z + 1 if other_point[0] == point[0] && other_point[1] == point[1]
        end
      end

      nil
    end
  end
end
