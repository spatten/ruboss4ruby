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
  
end