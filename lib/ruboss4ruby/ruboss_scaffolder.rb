#!/usr/bin/env ruby

def ruboss_scaffold(name, &block)
  RubossScaffold.new(name, &block)  
end

class RubossScaffold
  attr_reader :name, :attributes
  
  def initialize(name, &block)
    @name = name
    @attributes = []
    yield self
  end
  
  %w(string text boolean integer float date datetime).each do |attribute_type|
    module_eval <<-END
      def #{attribute_type}(*args)
        args.each do |arg|
          @attributes.push(arg.to_s + ":#{attribute_type}")
        end
      end
    END
  end
  
  def to_s
    "#{@name} #{@attributes.join(" ")}"
  end
  
  def run
    `script/generate ruboss_scaffold #{self}`
  end
  
end