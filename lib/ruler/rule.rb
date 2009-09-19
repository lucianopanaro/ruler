module Ruler
  class Rule
    attr_accessor :attribute
    attr_accessor :evaluator

    def initialize
      @attribute = attribute
    end

    def evaluator=(value)
      raise ArgumentError, "Value is not an Evaluator" unless value.kind_of?(Evaluators::Base)
      @evaluator = value
    end

    def is(attribute)
      @evaluator = Evaluators::Is.new
      @evaluator.attribute = attribute
      self
    end

    def is_not(attribute)
      @evaluator = Evaluators::IsNot.new
      @evaluator.attribute = attribute
      self
    end
  end
end
