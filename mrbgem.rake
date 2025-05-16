MRuby::Gem::Specification.new('mruby-class-attribute') do |spec|
  spec.license = 'MIT'
  spec.author = 'Hanami developers (ported by Paweł Świątkowski)'
  spec.summary = 'Inheritable class attributes ported from Hanami'

  spec.test_rbfiles = Dir.glob("#{dir}/test/*_test.rb")
end
