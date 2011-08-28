require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutMethodAdded < EdgeCase::Koan
  
  class Cat
    @num_of_methods = 0
    
    def self.method_added(name)
      @num_of_methods += 1
    end

    def miaow  
    end

    def speak
    end

    def self.num_of_methods
      @num_of_methods
    end
  end
    
  def test_method_added_hook_method_is_called_for_new_methods
    assert_equal 2, Cat.num_of_methods
  end
end
