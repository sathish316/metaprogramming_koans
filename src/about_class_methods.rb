require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutClassMethods < EdgeCase::Koan
  
  class Foo
    def self.say_hello
      "Hello"
    end
  end

  def test_class_is_an_instance_of_class_Class
    assert_equal true, Foo.class == Class
  end
  
  def test_class_methods_are_just_singleton_methods_on_the_class
    assert_equal "Hello", Foo.say_hello
  end

  def test_classes_are_not_special_and_are_just_like_other_objects
    assert_equal true, Foo.is_a?(Object)
    assert_equal true, Foo.superclass == Object 
  end
end
