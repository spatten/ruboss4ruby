# Used to create: Rails Model, Rails Controller, Rails Migration, Flex Model and Flex views.
# Here's a sample ruboss_scaffolder file:
#
# require 'ruboss_scaffolder'
# 
# ruboss_scaffold('user') do |s|
#   s.string :first_name
#   s.string :last_name
#   s.has_many :projects
# end
# 
# ruboss_scaffold('project') do |s|
#   s.string :name
#   s.date :start_date, :completion_date
#   s.has_many :tasks
#   s.belongs_to :user
# end
# 
# ruboss_scaffold('task') do |s|
#   s.string :name
#   s.boolean :completed
#   s.belongs_to :project
# end
#
# Note that:
#    You can have multiple entries per line
#    You can use belongs_to, has_one and has_many
#    You should use the singular for the scaffold name ('task', not 'tasks').
#
# Scaffold files should be placed in config/scaffolder.  You  will see a file called 'sample_ruboss_scaffolder.rb' there.
# To run the scaffold, just run it as a regular Ruby file:
# ruby config/scaffolder/some_scaffold_file.rb


def ruboss_scaffold(name, &block)
  RubossScaffolder.new(name, &block)  
end

class RubossScaffolder
  attr_reader :name
  
  ATTRIBUTE_TYPES = %w(string text boolean integer float date datetime)
  FLAGS = %w(skip-timestamps skip-migration flex-only)
  
  def initialize(name, &block)
    @name = name
    @has_manies = []
    @belongs_tos = []
    @has_ones = []
    @attributes = []
    yield self
    run
  end
  
  ATTRIBUTE_TYPES.each do |attribute_type|
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
  
  # TODO: ruboss_scaffold_generator currenly barfs on the --skip-timestamps and --skip-migration options.
  #       It should pass them along to scaffold_generator.
  FLAGS.each do |flag|
    underscored_flag = flag.gsub('-', '_')
    module_eval <<-END
      def #{underscored_flag}
        @#{underscored_flag} = true
      end
    END
  end
  
  def to_s
    [name,flags,attributes_string,references_string].compact.join(" ")
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
  
  def flags
    ret = []
    FLAGS.each do |flag|
      underscored_flag = flag.gsub('-', '_')
      ret.push("--#{flag}") if instance_variable_get("@" + underscored_flag)
    end
    ret.join(" ") unless ret.empty?
  end
  
  def run
    puts "running: ruboss_scaffold #{self}"
    `script/generate ruboss_scaffold #{self}`
    puts 'done ...'
    sleep 1
  end
  
end