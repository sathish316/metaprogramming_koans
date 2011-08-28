require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutClassInheritance < EdgeCase::Koan

  def test_singleton_class_can_be_used_to_define_singleton_methods
    animal = "cat"
    class << animal
      def speak
        "miaow"
      end
    end
    assert_equal "miaow", animal.speak
  end

  class Foo
    class << self
      def say_hello
        "Hello"
      end
    end
  end

  def test_singleton_class_can_be_used_to_define_class_methods
    assert_equal "Hello", Foo.say_hello
  end
  
end
