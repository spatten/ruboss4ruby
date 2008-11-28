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
  
  def string(name)
    @attributes.push("#{name}:string")
  end
  
  def to_s
    "#{@name} #{@attributes.join(" ")}"
  end
  
  def line
    
  end
  
end