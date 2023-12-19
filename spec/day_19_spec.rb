# frozen_string_literal: true

require_relative "../day-19/aplenty"

describe Aplenty, day: 19 do
  subject(:aplenty) { described_class.new(input) }

  context "with sample input", sample: true do
    let(:input) do
      <<~INPUT
        px{a<2006:qkq,m>2090:A,rfg}
        pv{a>1716:R,A}
        lnx{m>1548:A,A}
        rfg{s<537:gd,x>2440:R,A}
        qs{s>3448:A,lnx}
        qkq{x<1416:A,crn}
        crn{x>2662:A,R}
        in{s<1351:px,qqz}
        qqz{s>2770:qs,m<1801:hdj,R}
        gd{a>3333:R,R}
        hdj{m>838:A,pv}

        {x=787,m=2655,a=1222,s=2876}
        {x=1679,m=44,a=2067,s=496}
        {x=2036,m=264,a=79,s=2244}
        {x=2461,m=1339,a=466,s=291}
        {x=2127,m=1623,a=2188,s=1013}
      INPUT
    end

    it "finds accepted parts", part: 1 do
      expect(aplenty.parts.filter(&:accepted?).map(&:rating).sum).to eq(19_114)
    end

    it "finds all part combinations", part: 2 do
      expect(aplenty.ranged_parts.filter(&:accepted?).map(&:combinations).sum).to eq(167_409_079_868_000)
    end
  end

  it "finds accepted parts", part: 1 do
    expect(aplenty.parts.filter(&:accepted?).map(&:rating).sum).to eq(374_873)
  end

  it "finds all part combinations", part: 2 do
    expect(aplenty.ranged_parts.filter(&:accepted?).map(&:combinations).sum).to eq(122_112_157_518_711)
  end
end
