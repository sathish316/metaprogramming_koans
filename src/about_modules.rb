require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutModules < EdgeCase::Koan
  
  module Greeting
    def say_hello
      "Hello"
    end
  end
  
  class Foo
    include Greeting
  end
  
  module Greeting
    def say_hello
      "Hi"
    end
  end
  
  def test_module_methods_are_active
    assert_equal "Hi", Foo.new.say_hello
  end
  
  def test_extend_adds_singleton_methods
    animal = "cat"
    animal.extend Greeting

    assert_equal "Hi", animal.say_hello
  end

  def test_another_way_to_add_singleton_methods_from_module
    animal = "cat"
    class << animal
      include Greeting
    end

    assert_equal "Hi", animal.say_hello
  end
  
  class Bar
    extend Greeting
  end
  
  def test_extend_adds_class_methods_or_singleton_methods_on_the_class
    assert_equal "Hi", Bar.say_hello
  end
  
  module Moo
    def instance_method
      :instance_value
    end

    module ClassMethods
      def class_method
        :class_value
      end
    end
  end

  class Baz
    include Moo
    extend Moo::ClassMethods
  end
  
  def test_include_instance_methods_and_extend_class_methods
    assert_equal :instance_value, Baz.new.instance_method
    assert_equal :class_value, Baz.class_method
  end
  
  module Moo
    def self.included(klass)
      #WRITE CODE HERE
      klass.extend(ClassMethods)
    end
  end

  class Foo
    include Moo
  end
  
  def test_included_is_a_hook_method_that_can_be_used_to_extend_automatically
    assert_equal :instance_value, Foo.new.instance_method
    assert_equal :class_value, Foo.class_method
  end
  
end
