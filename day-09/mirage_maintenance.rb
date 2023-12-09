# frozen_string_literal: true

require_relative "../lib/newline_input"

class MirageMaintenance
  include NewlineInput

  def predict!
    histories.each do |history|
      hs = [history]
      hs << hs[-1].each_cons(2).map { |l, r| r - l } until hs[-1].uniq.size == 1

      predicted_next = (hs[-2].size * hs[-1][0]) + hs[-2][0]
      predicted_last = (-1 * hs[-1][0]) + hs[-2][0]
      hs[-2] << predicted_next
      hs[-2].unshift(predicted_last)

      (hs.size - 2).times do |i|
        i = -3 + (-1 * i)
        predicted_next = hs[i][-1] + hs[i + 1][-1]
        predicted_last = hs[i][0] - hs[i + 1][0]
        hs[i] << predicted_next
        hs[i].unshift(predicted_last)
      end
    end
  end

  def histories
    @histories ||= lines.map do |line|
      line.split.map(&:to_i)
    end
  end
end
