require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutBlocks < EdgeCase::Koan

  def test_calling_a_lambda
    l = lambda {|a| a + 1}
    assert_equal __, l.call(99)
  end

  def test_calling_a_proc
    p = Proc.new {|a| a + 1}
    assert_equal __, p.call(99)
  end
  
  def convert(&block)
    block
  end
  
  def test_block_is_proc
    b = convert {|a| a + 1}
    assert_equal __, b.class
    assert_equal __, b.call(99)
  end

  def test_proc_takes_fewer_or_more_arguments
    p = Proc.new {|a, b, c| a.to_i + b.to_i + c.to_i}
    assert_equal __, p.call(1,2)
    assert_equal __, p.call(1,2,3,4)
  end

  def test_lambda_does_not_take_fewer_or_more_arguments
    l = lambda {|a, b, c| a.to_i + b.to_i + c.to_i}
    assert_raises(ArgumentError) do
      l.call(1, 2)
    end

    assert_raises(ArgumentError) do
      l.call(1,2,3,4)
    end
  end

  def method(lambda_or_proc)
    lambda_or_proc.call
    :from_method
  end
  
  def test_return_inside_lambda_returns_from_the_lambda
    l = lambda { return :from_lambda }
    result = method(l)
    assert_equal __, result
  end

  def test_return_inside_proc_returns_from_the_context
    p = Proc.new { return :from_proc }
    result = method(p)
    # The execution never reaches this line because Proc returns
    # outside the test method
    assert_equal __, p.call
  end
end
