module ClassAttribute
  # This is a class attributes set
  class Attributes
    def initialize(attributes: {})
      @attributes = attributes
    end

    def []=(key, value)
      @attributes[key.to_sym] = value
    end

    def [](key)
      @attributes[key]
    end

    def dup
      attributes = {}
      @attributes.each do |key, value|
        attributes[key.to_sym] = value.dup
      end

      self.class.new(attributes: attributes)
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def self.extended(base)
      base.class_eval do
        @__class_attributes ||= Attributes.new
      end
    end

    def class_attribute(*attributes)
      attributes.each do |attr|
        singleton_class = class << self; self; end

        # define getter
        singleton_class.define_method(attr) do
          class_attributes[attr]
        end

        # define setter
        singleton_class.define_method("#{attr}=") do |value|
          class_attributes[attr] = value
        end
      end
    end

    protected

    def inherited(subclass)
      ca = class_attributes.dup
      subclass.class_eval do
        @__class_attributes = ca
      end

      super
    end

    private

    def class_attributes
      @__class_attributes
    end
  end
end
