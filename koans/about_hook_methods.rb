require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutHookMethods < EdgeCase::Koan

  module Bar
    def self.included(klass)
      @included = true
    end

    def self.included?
      @included
    end
  end
  
  class Foo
    include Bar
  end
  
  def test_included_hook_method_is_called_when_module_is_included_in_class
    assert_equal __, Bar.included?
  end
  
  class Parent
    def self.inherited(klass)
      @inherited = true
    end

    def self.inherited?
      @inherited
    end
  end

  class Child < Parent
  end
  
  def test_inherited_hook_method_is_called_when_class_is_subclassed
    assert_equal __, Parent.inherited? 
  end
  
  class ::Struct
    @children = []
    
    def self.inherited(klass)
      @children << klass
    end

    def self.children
      @children
    end
  end
  
  Cat = Struct.new(:name, :tail)
  Dog = Struct.new(:name, :legs)
  
  def test_inherited_can_track_subclasses
    assert_equal [Cat, Dog], Struct.children
  end
  
  class ::Module
    def const_missing(name)
      if name.to_s =~ /(X?)(IX|IV|(V?)(I{0,3}))/
        to_roman($~)
      end
    end
  end
  
  def test_const_missing_hook_method_can_be_used_to_dynamically_evaluate_constants
    assert_equal __, VIII
  end

  class Color
    def self.const_missing(name)
      const_set(name, new)
    end
    
  end

  def test_const_set_can_be_used_to_dynamically_create_constants
    Color::Red
    assert_equal __, defined?(Color::Red)
  end
end

def to_roman(match)
  value = 0
  value += 10 if match[1] == 'X'
  value += 9 if match[2] == 'IX'
  value += 4 if match[2] == 'IV'
  value += 5 if match[3] == 'V'
  value += match[4].chars.count if match[4]
  value
end
