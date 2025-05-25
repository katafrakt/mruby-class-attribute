class ClassAttributeTest
  include ClassAttribute
  class_attribute :callbacks, :functions, :values, :initial
  self.callbacks = [:a]
  self.values    = [1]
end

class SubclassAttributeTest < ClassAttributeTest
  class_attribute :subattribute
  self.functions    = %i[x y]
  self.subattribute = 42
end

class SubSubclassAttributeTest < SubclassAttributeTest
end

class Vehicle
  include ClassAttribute
  class_attribute :engines, :wheels

  self.engines = 0
  self.wheels  = 0
end

class Car < Vehicle
  self.engines = 1
  self.wheels  = 4
end

class Airplane < Vehicle
  self.engines = 4
  self.wheels  = 16
end

class SmallAirplane < Airplane
  self.engines = 2
  self.wheels  = 8
end

class DoubleInclude
  include ClassAttribute
  class_attribute :foo
  self.foo = 1

  include ClassAttribute
  class_attribute :bar
  self.bar = 2
end

module Lts
  module Routing
    class Resource
      class Action
        include ClassAttribute
        class_attribute :verb
      end

      class New < Action
        self.verb = :get
      end
    end

    class Resources < Resource
      class New < Resource::New
      end
    end
  end
end

assert 'false' do
  assert_equal 1, 2
end

assert 'initial value is nil' do
  assert_equal ClassAttributeTest.initial, nil
end

assert 'the value it is inherited by subclasses' do
  assert_equal SubclassAttributeTest.callbacks, [:a]
end

assert 'if the superclass value changes it does not affects subclasses' do
  ClassAttributeTest.functions = [:y]
  assert_equal SubclassAttributeTest.functions, %i[x y]
end

assert 'if the subclass value changes it does not affects superclass' do
  SubclassAttributeTest.values = [3, 2]
  assert_equal ClassAttributeTest.values, [1]
end

assert 'when the subclass is defined in a different namespace it refers to the superclass value' do
  assert_equal Lts::Routing::Resources::New.verb, :get
end

assert 'if the subclass defines an attribute it should not be available for the superclass' do
  assert_raise(NoMethodError) do
    ClassAttributeTest.subattribute
  end
end

assert 'if the subclass defines an attribute it should be available for its subclasses' do
  assert_equal SubSubclassAttributeTest.subattribute, 42
end

assert 'preserves values within the inheritance chain' do
  assert_equal Vehicle.engines, 0
  assert_equal Vehicle.wheels, 0

  assert_equal Car.engines, 1
  assert_equal Car.wheels, 4

  assert_equal Airplane.engines, 4
  assert_equal Airplane.wheels, 16

  assert_equal SmallAirplane.engines, 2
  assert_equal SmallAirplane.wheels, 8
end

assert 'preserves class attributes if module is included multiple times' do
  assert_equal DoubleInclude.foo, 1
end
