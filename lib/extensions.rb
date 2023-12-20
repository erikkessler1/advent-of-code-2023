# frozen_string_literal: true

class Object
  def map
    yield self
  end

  def non_nil?
    true
  end
end

class NilClass
  def map; end

  def non_nil?
    false
  end
end

class Array
  def least_common_multiple
    map do |n|
      prime_factors(n).tally
    end.reduce do |factor_tally, other_factor_tally|
      factor_tally.merge(other_factor_tally) do |_, *conflict|
        conflict.max
      end
    end.keys.reduce(&:*)
  end

  private

  def prime_factors(n)
    factors = []

    while n.even?
      factors << 2
      n /= 2
    end

    i = 3
    max = Math.sqrt(n)
    until i > max
      while (n % i).zero?
        factors << i
        n /= i
      end
      i += 2
    end

    factors << n if n > 2

    factors
  end
end
