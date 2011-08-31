require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Based on Yehuda Katz's article: Metaprogramming in Ruby: It's all about the self
# http://yehudakatz.com/2009/11/15/metaprogramming-in-ruby-its-all-about-the-self/

class AboutSelf < EdgeCase::Koan

  class Person
    def self.species
      "Homo Sapiens"
    end
  end

  def test_self_inside_class_defines_class_method
    assert_equal "Homo Sapiens", Person.species
  end

  @@self_inside_class = class Person
    self
  end

  def test_self_inside_class_is_the_class_itself
    assert_equal Person, @@self_inside_class
  end

  class Dog ; end

  class << Dog
    def species
      "Canis Lupus"
    end
  end

  def test_self_inside_class_ltlt_class_is_the_metaclass
    assert_equal "Canis Lupus", Dog.species
  end

  class Cat
    class << self
      def species
        "Felis Catus"
      end
    end
  end

  def test_self_inside_class_ltlt_self_is_the_metaclass
    # inside class self = Cat
    # class << self is same as class << Cat
    assert_equal "Felis Catus", Cat.species
  end

  class Lion ; end

  @@object = Lion.new
  @@self_inside_instance_eval_of_object = @@object.instance_eval { self }

  def test_self_inside_instance_eval_of_object_is_the_object_itself
    assert_equal @@object, @@self_inside_instance_eval_of_object
  end

  @@self_inside_instance_eval_of_class = Lion.instance_eval { self }

  def test_self_inside_instance_eval_of_class_is_the_class_itself
    assert_equal Lion, @@self_inside_instance_eval_of_class
  end

  Lion.instance_eval do
    def species
      "Panthera Leo"
    end
  end

  def test_self_inside_instance_eval_is_class_and_defines_class_methods
    assert_equal "Panthera Leo", Lion.species
  end

  class Tiger ; end

  def Tiger.species
    "Panthera Tigris"
  end

  def test_singleton_method_on_Class_defines_a_class_method
    assert_equal "Panthera Tigris", Tiger.species
  end

  class Person
    def name
      "Matz"
    end
  end

  def test_methods_defined_in_a_class_are_instance_methods
    assert_equal "Matz", Person.new.name
  end

  @@self_inside_class_eval = Cat.class_eval { self }

  def test_self_inside_class_eval_is_the_class_itself
    assert_equal Cat, @@self_inside_class_eval
  end

  Cat.class_eval do
    def name
      "Frisky"
    end
  end

  def test_class_eval_defines_methods_in_class
    assert_equal "Frisky", Cat.new.name
  end

  class ::Class
    def loud_name
      "#{name.upcase}"
    end
  end

  def test_methods_defined_in_Class_class_is_available_to_all_classes
    # All classes are subclasses of Class and inherit methods of Class
    assert_match "PERSON", Person.loud_name
  end

end
