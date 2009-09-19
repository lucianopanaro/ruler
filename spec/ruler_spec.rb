require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ruler" do
  describe "Processor" do
    describe "initialization" do
      it "should raise an error if block is not given" do
        lambda {
          Ruler::Processor.new
        }.should raise_error(ArgumentError, "You have to define your rules in a block")

        lambda {
          Ruler::Processor.new {}
        }.should_not raise_error(ArgumentError, "You have to define your rules in a block")
      end

      it "block should pass a RulesList" do
        arg = nil
        Ruler::Processor.new { |rules| arg = rules }
        arg.should be_instance_of(Ruler::RulesList)
      end
    end

    it "should be runnable" do
      processor = Ruler::Processor.new {}
      processor.should respond_to(:run)
    end
  end

  describe "RulesList" do
    describe "adding a rule" do
      it "should return an instance of a rule" do
        list = Ruler::RulesList.new
        list.add(:name).should be_instance_of(Ruler::Rule)
      end

      it "should have the new rule in its collection" do
        list = Ruler::RulesList.new
        rule = list.add(:name)
        list.include?(rule)
      end
    end
  end

  describe "Rule" do
    it "should have an attribute" do
      rule = Ruler::Rule.new
      rule.attribute = :name
      rule.attribute.should equal :name
    end

    it "should have an evaluator" do
      rule = Ruler::Rule.new
      rule.evaluator = Ruler::Evaluators::Is.new
      rule.evaluator.should be_instance_of(Ruler::Evaluators::Is)
    end

    it "should require evaluator to be instance of Ruler::Evaluator::Base" do
      rule = Ruler::Rule.new
      lambda { rule.evaluator = "invalid" }.should raise_error(ArgumentError, "Value is not an Evaluator")
    end

    describe "setting an evaluator with access methods" do
      it "sets an Is evaluator with attr when calling #is(attr)" do
        rule = Ruler::Rule.new
        rule.is(:valid?)
        rule.evaluator.should be_instance_of(Ruler::Evaluators::Is)
        rule.evaluator.attribute.should == :valid?
      end

      it "sets an Is Not evaluator with attr when calling #is_not(attr)" do
        rule = Ruler::Rule.new
        rule.is_not(:valid?)
        rule.evaluator.should be_instance_of(Ruler::Evaluators::IsNot)
        rule.evaluator.attribute.should == :valid?
      end
    end
  end

  describe "Evaluators" do
    describe "Base" do
      it "should be processable" do
        Ruler::Evaluators::Base.new.should respond_to(:process)
      end

      it "should have an attribute" do
        evaluator = Ruler::Evaluators::Base.new
        evaluator.attribute = :empty?
        evaluator.attribute.should == :empty?
      end

      it "should require a subject to process" do
        lambda { Ruler::Evaluators::Base.new.process }.should raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
      end

      it "should require a concrete implementation" do
        lambda { Ruler::Evaluators::Base.new.process(:subject) }.should raise_error(NotImplementedError)
      end
    end

    describe "Is" do
      describe "processing" do
        it "should return true if method is not false" do
          is = Ruler::Evaluators::Is.new
          is.attribute = :empty?
          is.process("").should == true
          is.attribute = :upcase
          is.process("").should == true
        end

        it "should return false if method is false" do
          is = Ruler::Evaluators::Is.new
          is.attribute = :empty?
          is.process("notempty").should == false
        end
      end
    end

    describe "IsNot" do
      describe "processing" do
        it "should return true if method is false" do
          is_not = Ruler::Evaluators::IsNot.new
          is_not.attribute = :empty?
          is_not.process("notempty").should == true
        end

        it "should return false if method is not false" do
          is_not = Ruler::Evaluators::IsNot.new
          is_not.attribute = :empty?
          is_not.process("").should == false
          is_not.attribute = :upcase
          is_not.process("").should == false
        end
      end
    end
  end
end
