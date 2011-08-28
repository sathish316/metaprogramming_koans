require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutClassAsConstant < EdgeCase::Koan
  
  class Foo
    def say_hello
      "Hi"
    end
  end
  
  def test_defined_tells_if_a_class_is_defined_or_not
    assert_not_nil defined?(Foo)
    assert_nil defined?(Bar)
  end

  def test_class_is_a_constant
    assert_equal "constant", defined?(Foo)
  end

  def test_class_constant_can_be_assigned_to_var
    my_class = Foo
    assert_equal "Hi", my_class.new.say_hello
  end
  
  @@return_value_of_class =
    class Baz
      def say_hi
        "Hello"
      end
      99
    end
    
  def test_class_definitions_are_active
    assert_equal 99, @@return_value_of_class
  end
  
  @@self_inside_a_class =
    class Baz
      def say_hi
        "Hi"
      end
      self
    end
    
  def test_self_inside_class_is_class_itself
    assert_equal Baz, @@self_inside_a_class
  end

  def test_class_is_an_object_of_type_class_and_can_be_created_dynamically
    cls = Class.new
    assert_match /Class/, cls.to_s
  end
end
