module Ruler
  module Evaluators
    class Is < Base
      def process(subject)
        subject.send(self.attribute) ? true : false
      end
    end
  end
end
