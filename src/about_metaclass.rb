require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Based on _why's article: Seeing Metaclasses clearly
# http://dannytatom.github.com/metaid/

class AboutMetaclass < EdgeCase::Koan

  class MailTruck
    attr_accessor :driver, :route
    def initialize(driver = nil, route = nil)
      @driver, @route = driver, route
    end
  end

  def setup
    @truck = MailTruck.new("Harold", ['12 Corrigan way', '23 Antler Ave'])
  end

  def test_class_of_an_object
    assert_equal MailTruck, @truck.class
  end

  def test_class_of_a_class
    assert_equal Class, MailTruck.class
  end

  def test_object_is_a_storage_for_variables
    assert_equal "Harold", @truck.driver
  end

  def test_object_can_hold_any_other_instance_variables
    @truck.instance_variable_set("@speed", 45)
    assert_equal 45, @truck.instance_variable_get("@speed")
  end

  def test_attr_accessor_defines_reader_and_writer
    @truck.driver = 'Kumar'
    assert_equal 'Kumar', @truck.driver
  end

  def test_classes_store_methods
    assert_equal true, MailTruck.instance_methods.include?(:driver)
  end

=begin

BasicObject
    |
  Object
    |
  Module
    |
  Class

=end

  def test_class_is_an_object
    assert_equal true, Class.is_a?(Object)
    assert_equal Module, Class.superclass
    assert_equal Object, Class.superclass.superclass
  end

  def test_class_has_object_id
    assert_equal true, @truck.object_id > 0
    assert_equal true, MailTruck.object_id > 0
  end

  def test_Object_class_is_Class
    assert_equal Class, Object.class
  end

  def test_Object_inherits_from_Basic_Object
    assert_equal BasicObject, Object.superclass
  end

  def test_Basic_Object_sits_at_the_very_top
    assert_equal nil, BasicObject.superclass
  end

  class MailTruck
    def has_mail?
      !(@mails.nil? || @mails.empty?)
    end
  end

  def test_metaclass_is_a_class_which_an_object_uses_to_redefine_itself
    assert_equal false, @truck.has_mail?
  end

  class ::Class
    def is_everything_an_object?
      true
    end
  end

  def test_metaclass_is_a_class_which_even_Class_uses_to_redefine_itself
    assert_equal true, Class.is_everything_an_object?
    assert_equal true, MailTruck.is_everything_an_object?
  end

  def test_singleton_methods_are_defined_only_for_that_instance
    red_truck = MailTruck.new
    blue_truck = MailTruck.new
    def red_truck.honk
      "Honk!Honk!"
    end

    assert_equal "Honk!Honk!", red_truck.honk
    assert_raises(NoMethodError) do
      blue_truck.honk
    end
  end

=begin

  MailTruck
     |
  Metaclass
     |
  @truck

=end

  def test_metaclass_sits_between_object_and_class
    assert_equal MailTruck, @truck.metaclass.superclass
  end

  def test_singleton_methods_are_defined_in_metaclass
    def @truck.honk
      "Honk"
    end
    assert_equal "Honk", @truck.honk
    assert_equal true, @truck.metaclass.instance_methods.include?(:honk)
    assert_equal true, @truck.singleton_methods.include?(:honk)
  end

  class ::Object
    def metaclass
      class << self ; self ; end
    end
  end

  def test_class_lt_lt_opens_up_metaclass
    klass = class << @truck ; self ; end
    assert_equal true, klass == @truck.metaclass
  end

  def test_metaclass_can_have_metaclass_ad_infinitum
    assert_equal false, @truck.metaclass.metaclass.nil?
    assert_equal false, @truck.metaclass.metaclass.metaclass.nil?
  end

  def test_metaclass_of_a_metaclass_does_not_affect_the_original_object
    def @truck.honk
      "Honk"
    end

    metaclass = @truck.metaclass
    def metaclass.honk_honk
      "Honk Honk"
    end

    assert_equal "Honk", @truck.honk
    assert_equal "Honk Honk", @truck.meta_eval { honk_honk }
    assert_raises(NoMethodError) do
      @truck.honk_honk
    end
  end

=begin
  MailTruck
     |
  Metaclass -> Metaclass -> Metaclass ...
     |
   @truck

=end
  class MailTruck
    @@trucks = []

    def MailTruck.add_truck(truck)
      @@trucks << truck
    end

    def MailTruck.count_trucks
      @@trucks.count
    end
  end

  def test_classes_can_have_class_variables
    red_truck = MailTruck.new
    blue_truck = MailTruck.new
    MailTruck.add_truck(red_truck)
    MailTruck.add_truck(blue_truck)

    assert_equal 2, MailTruck.count_trucks
  end

  class MailTruck
    @trucks = []

    def MailTruck.add_a_truck(truck)
      @trucks << truck
    end

    def MailTruck.total_trucks
      @trucks.count
    end
  end

  def test_classes_can_have_instance_variables
    red_truck = MailTruck.new
    blue_truck = MailTruck.new
    green_truck = MailTruck.new
    MailTruck.add_a_truck(red_truck)
    MailTruck.add_a_truck(blue_truck)
    MailTruck.add_a_truck(green_truck)

    assert_equal 3, MailTruck.total_trucks
  end

  def test_class_variable_and_class_instance_variable_are_not_the_same
    assert_equal false, MailTruck.count_trucks == MailTruck.total_trucks
  end

  class MailTruck
    def say_hi
      "Hi! I'm one of #{@@trucks.length} trucks"
    end
  end

  def test_only_class_variables_can_be_accessed_by_instances_of_class
    MailTruck.add_truck(@truck)
    assert_equal "Hi! I'm one of 3 trucks", @truck.say_hi
  end

  def test_class_methods_are_defined_in_metaclass_of_class
    assert_equal true, MailTruck.metaclass.instance_methods.include?(:add_truck)
    assert_equal true, MailTruck.metaclass.instance_methods.include?(:add_a_truck)
  end

  class MailTruck
    def self.add_another_truck(truck)
      @@trucks << truck
    end
  end

  def test_class_methods_can_also_be_defined_using_self
    MailTruck.add_another_truck(MailTruck.new)
    assert_equal 4, MailTruck.count_trucks
  end

  def test_all_class_methods_are_defined_in_metaclass_of_class
    assert_equal true, MailTruck.metaclass.instance_methods.include?(:add_another_truck)
  end

  class ::Object
    def meta_eval(&block)
      metaclass.instance_eval(&block)
    end
    # Add methods to metaclass
    def meta_def name, &block
      meta_eval { define_method name, &block }
    end
  end

  class MailTruck
    def self.made_by(name)
      meta_def :company do
        name
      end
    end
  end

  class ManualTruck < MailTruck
    made_by "TrucksRUs"
  end

  class RobotTruck < MailTruck
    made_by "Lego"
  end

  def test_meta_def_can_be_used_to_add_methods_dynamically_to_metaclass
    assert_equal "TrucksRUs", ManualTruck.company
    assert_equal "Lego", RobotTruck.company
  end

  class ::Object
    # Defines an instance method within a class
    def class_def name, &block
      class_eval { define_method name, &block }
    end
  end

  class MailTruck
    def self.check_for(attr)
      class_def :can_drive? do
        instance_variable_get("@#{attr}") != nil
      end
    end
  end

  class ManualTruck < MailTruck
    check_for :driver
  end

  class RobotTruck < MailTruck
    check_for :route
  end

  def test_class_def_can_be_used_to_add_instance_methods_dynamically
    assert_equal false, ManualTruck.new.can_drive?
    assert_equal false, RobotTruck.new.can_drive?

    assert_equal true, ManualTruck.new('Harold', nil).can_drive?
    assert_equal true, RobotTruck.new(nil, ['SF']).can_drive?
  end

  class ::Object
    def meta_eval(&block)
      metaclass.instance_eval(&block)
    end

    # Add methods to metaclass
    def meta_def name, &block
      meta_eval { define_method name, &block }
    end

    # Defines an instance method within a class
    def class_def name, &block
      class_eval { define_method name, &block }
    end
  end

end
