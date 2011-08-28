require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutSingletonMethods < EdgeCase::Koan

  def test_instance_method_calls_method_on_class
    animal = "cat"
    assert_equal "CAT", animal.upcase
  end

  def test_instance_method_calls_method_on_parent_class_if_not_found_in_class
    animal = "cat"
    assert_equal false, animal.frozen?
  end

  def test_singleton_method_calls_method_on_anonymous_or_ghost_or_eigen_or_meta_class
    animal = "cat"
    def animal.speak
      "miaow"
    end
    assert_equal "miaow", animal.speak
  end

  def test_singleton_method_is_available_only_on_that_instance
    cat = "cat"
    def cat.speak
      "miaow"
    end
    dog = "dog"
    assert_raises(NoMethodError) do
      dog.speak
    end
  end
end
