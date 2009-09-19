module Ruler
  class RulesList
    include Enumerable

    def initialize
      @rules = []
    end

    def add(attribute)
      Rule.new.tap do |rule|
        rule.attribute = attribute
        @rules << rule
      end
    end

    def each
      @rules.each { |i| yield i }
    end
  end
end
