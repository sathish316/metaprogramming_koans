require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutBinding < EdgeCase::Koan
  
  class Foo
    def initialize
      @ivar = 22
    end
    
    def bar(param)
      lvar = 11
      binding
    end
  end
    
  def test_binding_binds_method_parameters
    binding = Foo.new.bar(99)
    assert_equal 99, eval("param", binding)
  end

  def test_binding_binds_local_vars
    binding = Foo.new.bar(99)
    assert_equal 11, eval("lvar", binding)
  end

  def test_binding_binds_instance_vars
    binding = Foo.new.bar(99)
    assert_equal 22, eval("@ivar", binding)
  end

  def test_binding_binds_blocks
    binding = Foo.new.bar(99) { 33 }
    assert_equal 33, eval("yield", binding)
  end

  def test_binding_binds_self
    foo = Foo.new
    binding = foo.bar(99)
    assert_equal foo, eval("self", binding)
  end
  
  def n_times(n)
    lambda {|value| n * value}
  end
    
  def test_lambda_binds_to_the_surrounding_context
    two_times = n_times(2)
    assert_equal 6, two_times.call(3)
  end

  def count_with_increment(start, inc)
    lambda { start += inc}
  end
  
  def test_lambda_remembers_state_of_bound_variables
    counter = count_with_increment(7, 3)
    assert_equal 10, counter.call
    assert_equal 13, counter.call
    assert_equal 16, counter.call
  end
  
end
