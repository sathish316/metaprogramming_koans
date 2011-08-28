require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutInstanceEvalAndClassEval < EdgeCase::Koan

  def test_instance_eval_executes_block_in_the_context_of_the_receiver
    assert_equal __, "cat".instance_eval { upcase }
  end
  
  class Foo
    def initialize
      @ivar = 99
    end
  end
  
  def test_instance_eval_can_access_instance_variables
    assert_equal __, Foo.new.instance_eval { @ivar }
  end

  class Foo
    private
    def secret
      123
     end
  end
  
  def test_instance_eval_can_access_private_methods
    assert_equal __, Foo.new.instance_eval { secret } 
  end

  def test_instance_eval_can_be_used_to_define_singleton_methods
    animal = "cat"
    animal.instance_eval do
      def speak
        "miaow"
      end
    end
    assert_equal __, animal.speak
  end
  
  class Cat
  end
  
  def test_instance_eval_can_be_used_to_define_class_methods
    Cat.instance_eval do
      def say_hello
        "Hello"
      end      
    end
      
    assert_equal __, Cat.say_hello
  end

  def test_class_eval_executes_block_in_the_context_of_class_or_module
    assert_equal __, Cat.class_eval { self }
  end

  def test_class_eval_can_be_used_to_define_instance_methods
    Cat.class_eval do
      def speak
        "miaow"
      end
    end
    assert_equal __, Cat.new.speak
  end
  
  def test_module_eval_is_same_as_class_eval
    Cat.module_eval do
      def miaow
        "miaow"
      end
    end
    assert_equal __, Cat.new.miaow
  end

  module Accessor
    def my_eval_accessor(name)
      # WRITE code here to generate accessors
      class_eval %{
        def #{name}
          @#{name}
        end

        def #{name}=(val)
          @#{name} = val
        end
      }
    end
  end

  class Cat
    extend Accessor
    my_eval_accessor :name
  end
  
  def test_class_eval_can_be_used_to_create_instance_methods_like_accessors
    cat = Cat.new
    cat.name = 'Frisky'
    assert_equal __, cat.name
  end

  module Hello
    def say_hello
      "hi"
    end
  end
  
  def test_class_eval_can_be_used_to_call_private_methods_on_class
    String.class_eval { include Hello }
    assert_equal __, "hello".say_hello
  end

  class Turtle
    attr_reader :path
    def initialize
      @path = ""
    end

    def right(n=1)
      @path << 'r' * n
    end

    def up(n=1)
      @path << 'u' * n
    end
  end

  class Turtle
    def move_yield(&block)
      yield
    end
  end
  
  def test_yield_executes_block_with_self_as_caller
    t = Turtle.new
    here = :here
    assert_equal __, t.move_yield { here } 
  end
  
  class Turtle
    def move_eval(&block)
      instance_eval(&block)
    end
  end
  
  def test_instance_eval_executes_block_with_self_as_called_object
    t = Turtle.new
    t.move_eval do
      right(3)
      up(2)
      right(1)
    end
    assert_equal __, t.path
  end
  
  class Turtle
    def move_eval_yield(&block)
      instance_eval { yield }
    end
  end
  
  def test_yield_inside_instance_eval_executes_block_with_self_as_caller
    still_here = :still_here
    t = Turtle.new
    assert_equal __, t.move_eval_yield { still_here }
  end
end
