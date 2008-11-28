#!/usr/bin/env ruby

def ruboss_scaffold(name, &block)
  RubossScaffold.new(name, &block)  
end

class RubossScaffold
  attr_reader :name
  
  def initialize(name, &block)
    @name = name
    @has_manies = []
    @belongs_tos = []
    @has_ones = []
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
  
  def has_many(*args)
    @has_manies += args
  end
  
  def belongs_to(*args)
    @belongs_tos += args
  end
  
  def has_one(*args)
    @has_ones += args    
  end
  
  # TODO: ruboss_scaffold_generator currenly barfs on the --skip-timestamps option.
  #       It should pass it along to scaffold_generator.
  def skip_timestamps
    @skip_timestamps = true
  end
  
  def to_s
    [name,options,attributes_string,references_string].compact.join(" ")
  end
  
  def attributes_string
    @attributes.join(" ")
  end
  
  
  
  def references_string
    ret = []
    ret.push("has_many:#{@has_manies.join(',')}") unless @has_manies.empty?
    ret.push("has_one:#{@has_ones.join(',')}") unless @has_ones.empty?
    ret.push("belongs_to:#{@belongs_tos.join(',')}") unless @belongs_tos.empty?
    ret.join(" ") unless ret.empty?
  end
  
  def options
    "--skip-timestamps" if @skip_timestamps
  end
  
  def run
    `script/generate ruboss_scaffold #{self}`
  end
  
end