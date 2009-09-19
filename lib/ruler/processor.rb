module Ruler
  class Processor
    def initialize
      raise ArgumentError, "You have to define your rules in a block" unless block_given?
      @rules_list = RulesList.new
      yield @rules_list
    end

    def run
    end
  end
end
