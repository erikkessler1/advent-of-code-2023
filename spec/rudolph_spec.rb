# frozen_string_literal: true

class Rudolph
  def self.red_nosed?
    true
  end
end

describe Rudolph do
  subject { described_class }

  it { is_expected.to be_red_nosed }
end
