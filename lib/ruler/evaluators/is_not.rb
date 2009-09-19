module Ruler
  module Evaluators
    class IsNot < Base
      def process(subject)
        subject.send(self.attribute) ? false : true
      end
    end
  end
end
