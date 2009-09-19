module Ruler
  module Evaluators
    class Base
      attr_accessor :attribute

      def process(value)
        raise NotImplementedError
      end
    end
  end
end
