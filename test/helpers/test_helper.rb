require 'test/unit'
RAILS_ROOT = File.join(File.dirname(__FILE__), '..') unless defined? RAILS_ROOT
require 'rubygems'

require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'active_record/fixtures'
require 'action_controller'
require 'action_controller/test_case'
require 'action_controller/assertions'
require 'action_controller/test_process'
require 'action_controller/integration'
require 'sqlite3'
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'ruboss4ruby')
require File.join(File.dirname(__FILE__), '..',  'models', 'note')
require File.join(File.dirname(__FILE__), '..', 'models', 'user')
require File.join(File.dirname(__FILE__), '..', 'models', 'project')
require File.join(File.dirname(__FILE__), '..', 'models', 'location')
require File.join(File.dirname(__FILE__), '..', 'models', 'task')




