# mruby-class-attribute

This gem provide class attributes for [mruby](https://mruby.org/) in a way that does not break the Principle of Least Surprise when used with inheritance.

## Problem

This gem solves the very old Ruby problem, in which class attributes are shared withing the whole hierarchy of classes. See this example:

``` ruby
class Vehicle
  @@wheels = 0

  def self.inspect_wheels
    puts "#{self}: #{@@wheels}"
  end
end

Vehicle.inspect_wheels

class Car < Vehicle
  @@wheels = 4
end

Car.inspect_wheels
Vehicle.inspect_wheels
```

The output of this code would be:

``` text
Vehicle: 0
Car: 4
Vehicle: 4
```

Note that the value for `Vehicle` class changes just because the class `Car`, inheriting from `Vehicle`, was defined. This leads to very subtle bugs and is why class attributes are generally discouraged.

## Solution

The gem ports the solution created by [Hanami](https://hanamirb.org/) web framework for Ruby. This is the counterpart code using `ClassAttribute`:

``` ruby
class Vehicle
  include ClassAttribute
  class_attribute :wheels
  self.wheels = 0

  def self.inspect_wheels
    puts "#{self}: #{self.wheels}"
  end
end

Vehicle.inspect_wheels

class Car < Vehicle
  self.wheels = 4
end

Car.inspect_wheels
Vehicle.inspect_wheels
```

In this case the output is as expected:

``` text
Vehicle: 0
Car: 4
Vehicle: 0
```

## License

The gem is distributed on a MIT license.

## Acknowledgements

The Hanami team, especially Luca Guidi, for writing the original implementation of the class attribute.
