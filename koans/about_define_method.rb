require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutDefineMethod < EdgeCase::Koan
  
  class Example
    def start
      def stop
        :stopped
      end
      :started
    end
  end
  
  def test_methods_can_define_other_methods
    o = Example.new
    assert_raises(NoMethodError) do
      o.stop
    end

    o.start

    assert_equal __, o.stop
  end
  
  class Example
    def foo
      def foo
        :new_value
      end
      :first_value
    end
  end
  
  def test_methods_can_redefine_themselves
    o = Example.new
    assert_equal __, o.foo
    assert_equal __, o.foo
  end

  class Multiplier
    def self.create_multiplier(n)
      define_method "times_#{n}" do |val|
        val * n
      end
    end

    10.times {|i| create_multiplier(i) }
  end

  def test_define_method_creates_methods_dynamically
    m = Multiplier.new
    assert_equal __, m.times_3(10)
    assert_equal __, m.times_6(10)
    assert_equal __, m.times_9(10)
  end
  
  module Accessor
    def my_writer(name)
      ivar_name = "@#{name}"
      define_method "#{name}=" do |value|
#Write code here to set value of ivar
      end
    end
    
    def my_reader(name)
      ivar_name = "@#{name}"
      define_method name do
#Write code here to get value of ivar
      end
    end
  end
  
  class Cat
    extend Accessor
    my_writer :name
    my_reader :name
  end
  
  def test_instance_variable_set_and_instance_variable_get_can_be_used_to_access_ivars
    cat = Cat.new
    cat.name = 'Fred'
    assert_equal __, cat.name
  end
end

