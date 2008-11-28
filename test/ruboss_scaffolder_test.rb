require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'ruboss4ruby', 'ruboss_scaffolder')

class RubossScaffolderTest < Test::Unit::TestCase
  
  def setup
    
  end
  
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
  
end