require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutPrototypeInheritance < EdgeCase::Koan

  def test_clone_copies_singleton_methods
    animal = "cat"
    def animal.speak
      "miaow"
    end
    other = animal.clone
    assert_equal "miaow", other.speak
  end

  def test_dup_does_not_copy_singleton_methods
    animal = "cat"
    def animal.speak
      "miaow"
    end
    other = animal.dup
    assert_raises(NoMethodError) do
      other.speak
    end
  end

  def test_state_is_inherited_in_prototype_inheritance
    animal = Object.new
    def animal.num_of_lives=(lives)
      @num_of_lives = lives
    end

    def animal.num_of_lives
      @num_of_lives
    end

    cat = animal.clone
    cat.num_of_lives = 9

    felix = cat.clone
    assert_equal 9, felix.num_of_lives
  end
  
end
