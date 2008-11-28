require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'ruboss4ruby', 'ruboss_scaffolder')

# Mock out run so we don't actually generate anything.
class RubossScaffolder
  
  def run
    
  end
  
end

class RubossScaffolderTest < Test::Unit::TestCase
  
  def test_scaffold_with_single_string_attribute
    
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :name
    end
    
    assert_equal 'users name:string', scaffolder.to_s
    
  end
  
  def test_scaffold_with_two_string_attributes
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name
      s.string :last_name
    end    
    assert_equal 'users first_name:string last_name:string', scaffolder.to_s
  end
  
  def test_scaffold_with_two_string_attributes_on_a_single_line
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name, :last_name
    end    
    assert_equal 'users first_name:string last_name:string', scaffolder.to_s    
  end
  
  def test_scaffold_with_lots_of_attributes
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name, :last_name
      s.float :balance
      s.integer :num_friends
      s.date :join_date
      s.datetime :last_activity
      s.boolean :active
    end
    
    assert_equal 'users first_name:string last_name:string balance:float num_friends:integer ' + 
                 'join_date:date last_activity:datetime active:boolean',
                 scaffolder.to_s

  end
  
  # note: ruboss_scaffold_generate barfs on --skip-timestamps
  def test_skip_timestamps_gets_passed_along
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name
      s.skip_timestamps
    end
    
    assert_match '--skip-timestamps', scaffolder.to_s
  end
  
  def test_multiple_flags_get_passed
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name
      s.skip_timestamps
      s.flex_only
      s.skip_migration
    end
    
    assert_match '--skip-timestamps', scaffolder.to_s
    assert_match '--skip-migration', scaffolder.to_s
    assert_match '--flex-only', scaffolder.to_s
  end
  
  def test_single_has_many_works
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name
      s.has_many :projects
    end
    
    assert_equal 'users first_name:string has_many:projects', scaffolder.to_s
  end
  
  def test_multiple_has_many_on_multiple_lines_works
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name
      s.has_many :projects
      s.has_many :tasks
    end
    
    assert_equal 'users first_name:string has_many:projects,tasks', scaffolder.to_s
  end  
  
  def test_multiple_has_many_on_single_line_works
    scaffolder = ruboss_scaffold('users') do |s|
      s.string :first_name
      s.has_many :projects, :tasks
    end
    
    assert_equal 'users first_name:string has_many:projects,tasks', scaffolder.to_s
  end    
  
end